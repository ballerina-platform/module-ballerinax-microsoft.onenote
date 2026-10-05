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

2. Add the OAuth 2.0 security scheme
- **Original**: The extracted subset has no `securitySchemes` and no top-level `security`, so the generated client has no `auth` configuration.
- **Updated**: Added an `oAuth2` scheme with the `authorizationCode` flow on the Microsoft identity platform v2.0 endpoints (`authorizationUrl`, `tokenUrl` and `refreshUrl` under `https://login.microsoftonline.com/common/oauth2/v2.0/`), the scopes `Notes.Create`, `Notes.Read`, `Notes.ReadWrite`, `Notes.Read.All`, `Notes.ReadWrite.All` and `offline_access`, and a top-level `security` requirement on all of them.
- **Reason**: The generated client needs the OAuth 2.0 refresh token configuration. No `clientCredentials` flow is declared because Microsoft Graph no longer supports application-only access to OneNote.

3. Remove the `discriminator` mappings
- **Original**: Seven schemas carry a `discriminator` on `@odata.type`, among them `microsoft.graph.entity`, whose mapping lists about 1,000 Graph types that are not part of this subset.
- **Updated**: Every `discriminator` is removed.
- **Reason**: The mappings point at schemas that do not exist in the subset and add nothing to the generated records.

4. Make `@odata.type` optional
- **Original**: `@odata.type` is listed under `required` in 37 schemas.
- **Updated**: `@odata.type` is removed from every `required` list; the property itself stays.
- **Reason**: Callers should not have to supply the type annotation, and the service does not require it in requests.

5. Collapse `anyOf` responses with a nullable object
- **Original**: 74 response schemas are `anyOf: [{$ref: X}, {type: object, nullable: true}]`.
- **Updated**: Each is replaced with `$ref: X`.
- **Reason**: The `anyOf` produces unnamed `InlineResponse2XX` union types and a loosely typed `record {}` alternative.

6. Replace the OData navigation-property boilerplate in descriptions
- **Original**: 2XX responses are described as `Retrieved navigation property`, `Created navigation property` or `Success`, request bodies as `New navigation property` or `New navigation property values`, and operation summaries read `Update the navigation property pages in me`.
- **Updated**: Response and request body descriptions that carry a typed body name the OneNote resource, for example `The OneNote page`. Summaries are rewritten from the path (`Update me onenote`). `Success` is kept on responses with no content.
- **Reason**: The boilerplate says nothing about the operation and becomes the generated method documentation. Applied to the aligned spec and copied here with `tooling/apply_descriptions.py`.

7. Strip the `dollar` prefix from the OData query parameter names
- **Original**: Parameters such as `$select` and `$expand` get the Ballerina name `dollarSelect` and `dollarExpand`.
- **Updated**: `x-ballerina-name` is `select`, `expand`, `orderby`, `count`, `filter`, `search`, `skip` and `top`.
- **Reason**: The record fields read as the OData options they set. Applied in the aligned spec, which is regenerated on every run.

8. Rename operations and schemas
- **Original**: Operation IDs are path-derived (`me.onenote.notebooks.sectionGroups.sections.ListPages`) and schemas carry the `MicrosoftGraph` prefix or are named after an inline body (`NotebookIdCopyNotebookBody`, `InlineResponse2XX`).
- **Updated**: Operations are named after the action and resource (`listNotebooks`, `createNotebookSection`, `getUserNotebook`; the `/users/{userId}` variants insert `User` after the verb, and `Nb` stands for `Notebook` inside longer chains such as `copyUserNbGroupSectionPageToSection`). Schemas drop the `MicrosoftGraph` prefix, and the inline bodies become `CopyNotebookRequest`, `CopyPageToSectionRequest`, `CopySectionToNotebookRequest`, `GetNotebookFromWebUrlRequest` and `PatchPageContentRequest`; the recent-notebooks response becomes `RecentNotebookCollectionResponse`.
- **Reason**: Stable, readable method and type names. The decisions are kept in `docs/spec/ai-mappings.json`.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json -o ballerina --mode client --client-methods remote --license docs/license.txt
```
Note: The license year is hardcoded to 2024, change if necessary.
