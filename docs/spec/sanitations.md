_Author_:  @DimuthuMadushan \
_Created_: 2026/10/05 \
_Updated_: 2026/10/05 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Microsoft OneNote.
The OpenAPI specification is obtained from [wso2/api-specs](https://github.com/wso2/api-specs/blob/main/openapi/microsoft/graph/v1.0/openapi.yaml).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. Extract the OneNote subset of Microsoft Graph v1.0
- **Original**: The Microsoft Graph v1.0 description covers the whole Graph API (about 44 MB, 11,546 paths).
- **Updated**: `docs/spec/openapi.yaml` is produced by `docs/resources/script.py`. It keeps every path whose first segment under `/me/` or `/users/{user-id}/` is `onenote` (206 paths, 318 operations), copied verbatim in upstream order, plus the transitive `$ref` closure of those paths in `components`. Group and site notebooks (`/groups/{group-id}/onenote...`, `/sites/{site-id}/onenote...`) are out of scope.
- **Reason**: The connector covers the OneNote surface of a user's notebooks only. Re-run `python3 docs/resources/script.py` to rebuild the subset from the source; the source is downloaded on first run and cached beside the script as `msgraph-v1.0-openapi.yaml` (untracked).

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
# TODO: Add OpenAPI CLI command used to generate the client
```
Note: The license year is hardcoded to 2024, change if necessary.
