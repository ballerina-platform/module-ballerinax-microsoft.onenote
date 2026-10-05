#!/usr/bin/env python3
"""
Extract the OneNote-scoped OpenAPI spec from the full Microsoft Graph v1.0 spec.

Downloads the Microsoft Graph v1.0 description published in
wso2/api-specs (openapi/microsoft/graph/v1.0/openapi.yaml, ~44 MB) and writes the
trimmed spec the `ballerinax/microsoft.onenote` connector is generated from:

  ../spec/openapi.yaml   the OneNote paths of the signed-in user (/me/onenote) and
                         of a given user (/users/{user-id}/onenote), components
                         pruned to the transitive $ref closure of those paths

The trimming rules:

  paths       every path whose first segment under /me or /users/{user-id} is
              `onenote`, copied verbatim, in upstream order. Group and site
              notebooks (/groups/{group-id}/onenote..., /sites/{site-id}/onenote...)
              are out of scope.
  info        upstream info, with title/description replaced by the OneNote text
  tags        the upstream tag entries actually used by the selected operations
  components  the transitive $ref closure of the selected paths, PLUS every
              `examples` entry whose name matches a kept schema (the upstream
              per-entity examples are not reachable by $ref)

The closure deliberately does NOT follow `discriminator.mapping` targets. Those
mappings are name-to-schema hints, not $refs, and following them would drag in
most of the upstream schemas. The `microsoft.graph.entity` schema therefore
arrives with a mapping pointing at schemas that are not in the subset; it has to
be dropped by hand once the operation trim has settled which schemas survive.

Paths resolve relative to this file, so it can be run from anywhere. The source
spec is cached beside the script and re-downloaded only when it is missing:

    python3 docs/resources/script.py
"""

from __future__ import annotations

import ssl
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path
from typing import Iterable

try:
    import yaml
except ImportError:
    sys.stderr.write("PyYAML is required: pip install pyyaml\n")
    sys.exit(1)

try:
    from yaml import CSafeLoader as YamlLoader, CSafeDumper as YamlDumper
except ImportError:
    from yaml import SafeLoader as YamlLoader, SafeDumper as YamlDumper


REPO_ROOT = Path(__file__).resolve().parent
SOURCE = REPO_ROOT / "msgraph-v1.0-openapi.yaml"
SOURCE_URL = (
    "https://raw.githubusercontent.com/wso2/api-specs/"
    "main/openapi/microsoft/graph/v1.0/openapi.yaml"
)
OUT = REPO_ROOT.parent / "spec" / "openapi.yaml"

# Owners whose notebooks are in scope: the signed-in user and a user by ID.
OWNER_PREFIXES = ("/me/", "/users/{user-id}/")

# First segment under an owner that marks the OneNote surface.
ONENOTE_ROOT = "onenote"

TITLE = "Microsoft OneNote API"
DESCRIPTION = (
    "Microsoft OneNote API. Subset of the Microsoft Graph v1.0 OpenAPI "
    "specification covering notebooks, section groups, sections, pages, page "
    "content, resources and long-running copy operations for the signed-in user "
    "and for users by ID."
)

# Emitted in this order, and only when non-empty.
COMPONENT_SECTIONS = (
    "schemas",
    "responses",
    "parameters",
    "examples",
    "requestBodies",
    "headers",
    "securitySchemes",
    "links",
    "callbacks",
)

OPERATION_KEYS = frozenset(
    ("get", "put", "post", "delete", "options", "head", "patch", "trace")
)

REF_PREFIX = "#/components/"


def _ssl_context() -> ssl.SSLContext:
    """Verify against certifi's CA bundle when it is installed.

    The python.org macOS builds ship without a usable trust store until
    `Install Certificates.command` has been run, and fail every HTTPS fetch with
    CERTIFICATE_VERIFY_FAILED. certifi is present far more often than that
    command has been run."""
    try:
        import certifi
    except ImportError:
        return ssl.create_default_context()
    return ssl.create_default_context(cafile=certifi.where())


def download_source(target: Path) -> None:
    print(f"Downloading {SOURCE_URL} ...", flush=True)
    try:
        with urllib.request.urlopen(SOURCE_URL, context=_ssl_context()) as response:
            payload = response.read()
    except urllib.error.HTTPError as exc:
        raise SystemExit(
            f"Download failed: HTTP {exc.code} for {SOURCE_URL}\n"
            f"Drop a local copy at {target.name} beside this script."
        ) from exc
    except urllib.error.URLError as exc:
        raise SystemExit(f"Download failed: {exc.reason} for {SOURCE_URL}") from exc
    target.write_bytes(payload)
    print(f"  wrote {target.name} ({target.stat().st_size:,} bytes)")


def load_source(path: Path) -> dict:
    with path.open(encoding="utf-8") as fh:
        return yaml.load(fh, Loader=YamlLoader)


def collect_refs(node) -> Iterable[str]:
    """Yield every `$ref` string inside `node`, skipping `discriminator` subtrees."""
    if isinstance(node, dict):
        for key, value in node.items():
            if key == "$ref" and isinstance(value, str):
                yield value
            elif key == "discriminator":
                continue
            else:
                yield from collect_refs(value)
    elif isinstance(node, list):
        for item in node:
            yield from collect_refs(item)


def collect_tags(paths: dict) -> set[str]:
    """Collect operation-level tag names from the selected paths."""
    used: set[str] = set()
    for path_item in paths.values():
        if not isinstance(path_item, dict):
            continue
        for key, op in path_item.items():
            if key in OPERATION_KEYS and isinstance(op, dict):
                used.update(t for t in op.get("tags") or [] if isinstance(t, str))
    return used


def walk_ref_closure(seed_node, components: dict) -> dict[str, set[str]]:
    """Transitively resolve every `$ref` reachable from `seed_node`."""
    kept: dict[str, set[str]] = {section: set() for section in COMPONENT_SECTIONS}
    queue = list(collect_refs(seed_node))
    while queue:
        ref = queue.pop()
        if not ref.startswith(REF_PREFIX):
            continue
        section, _, name = ref[len(REF_PREFIX):].partition("/")
        if section not in kept or not name or name in kept[section]:
            continue
        kept[section].add(name)
        component = components.get(section, {}).get(name)
        if component is None:
            # Dangling upstream ref — record but don't crash.
            continue
        queue.extend(collect_refs(component))
    return kept


def add_entity_examples(kept: dict[str, set[str]], components: dict) -> None:
    """Keep the per-entity example whose name matches a kept schema.

    Upstream files one `components.examples` entry per entity type, named
    identically to the schema. Nothing `$ref`s them, so the closure never
    reaches them; they are matched by name instead."""
    available = components.get("examples") or {}
    kept["examples"].update(name for name in kept["schemas"] if name in available)


def subset_components(components: dict, kept: dict[str, set[str]]) -> dict:
    """Project `components` down to `kept`, preserving upstream key order."""
    out: dict = {}
    for section in COMPONENT_SECTIONS:
        names = kept.get(section) or set()
        if not names:
            continue
        source = components.get(section) or {}
        subset = {name: source[name] for name in source if name in names}
        if subset:
            out[section] = subset
    return out


def count_ops(paths: dict) -> int:
    return sum(
        sum(1 for key in item if key in OPERATION_KEYS)
        for item in paths.values()
        if isinstance(item, dict)
    )


def is_onenote_path(path: str) -> bool:
    for prefix in OWNER_PREFIXES:
        if path.startswith(prefix):
            return path[len(prefix):].split("/", 1)[0] == ONENOTE_ROOT
    return False


def build_output(source_doc: dict) -> dict:
    selected_paths = {
        path: item
        for path, item in source_doc["paths"].items()
        if is_onenote_path(path)
    }
    if not selected_paths:
        raise SystemExit("No OneNote paths matched — is the source spec correct?")

    components = source_doc.get("components") or {}
    kept = walk_ref_closure(selected_paths, components)
    add_entity_examples(kept, components)
    pruned_components = subset_components(components, kept)

    used_tag_names = collect_tags(selected_paths)
    pruned_tags = [
        tag
        for tag in source_doc.get("tags") or []
        if isinstance(tag, dict) and tag.get("name") in used_tag_names
    ]

    info = dict(source_doc.get("info") or {})
    info["title"] = TITLE
    info["description"] = DESCRIPTION

    out: dict = {"openapi": source_doc["openapi"], "info": info}
    if "servers" in source_doc:
        out["servers"] = source_doc["servers"]
    if pruned_tags:
        out["tags"] = pruned_tags
    out["paths"] = selected_paths
    out["components"] = pruned_components
    return out


def write_yaml(target: Path, doc: dict) -> None:
    class Dumper(YamlDumper):
        # The spec reuses identical sub-documents; anchors/aliases would be
        # valid YAML but most OpenAPI tooling chokes on them.
        def ignore_aliases(self, data):
            return True

    with target.open("w", encoding="utf-8") as fh:
        yaml.dump(
            doc,
            fh,
            Dumper=Dumper,
            sort_keys=False,
            allow_unicode=True,
            width=120,
            default_flow_style=False,
        )


def main() -> int:
    if not SOURCE.exists():
        download_source(SOURCE)

    t0 = time.monotonic()
    print(f"Loading {SOURCE.name} ({SOURCE.stat().st_size:,} bytes) ...", flush=True)
    source_doc = load_source(SOURCE)
    print(f"  {len(source_doc['paths']):,} paths, "
          f"{len(source_doc.get('components', {}).get('schemas', {})):,} schemas "
          f"({time.monotonic() - t0:.1f}s)")

    print(f"Selecting OneNote paths under {', '.join(OWNER_PREFIXES)} ...")
    doc = build_output(source_doc)
    print(f"  {len(doc['paths']):,} paths, {count_ops(doc['paths']):,} operations")
    for section, entries in doc["components"].items():
        print(f"  {section:<12} {len(entries):,}")

    write_yaml(OUT, doc)
    print(f"\nWrote {OUT.relative_to(REPO_ROOT.parent.parent)} ({OUT.stat().st_size:,} bytes) in {time.monotonic() - t0:.1f}s")
    return 0


if __name__ == "__main__":
    sys.exit(main())
