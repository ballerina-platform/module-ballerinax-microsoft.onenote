# Running Tests

The test suite covers the core OneNote workflows of the connector: listing, creating, reading, updating and deleting notebooks, sections, section groups and pages; reading and patching page content; copying notebooks and pages; finding a notebook from its web URL; reading a long-running operation; and listing another user's notebooks.

## Prerequisites

To run the tests against the live Microsoft Graph API you need an application registered in Microsoft Entra ID and an access token for the `Notes.ReadWrite`, `Notes.Create` and `Notes.ReadWrite.All` delegated permissions. Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-microsoft.onenote/blob/main/ballerina/README.md#setup-guide) to obtain the credentials.

## Test environments

There are two test environments. The default is a mock server for the OneNote API. The other is the live Microsoft Graph API.

 Test Groups | Environment
-------------|------------------------------------------------
 mock_tests  | Mock server for the OneNote API (default)
 live_tests  | Microsoft Graph API

## Running tests against the mock server

No configuration is needed. When `IS_LIVE_SERVER` is not set to `true`, the tests run against the mock server on port `9090`.

```bash
./gradlew clean test
```

## Running tests against the live Microsoft Graph API

Set the following environment variables, then run the tests.

| Variable | Description |
|----------|-------------|
| `IS_LIVE_SERVER` | `true` to target Microsoft Graph |
| `MICROSOFT_ONENOTE_ACCESS_TOKEN` | OAuth 2.0 access token of the signed-in user |
| `MICROSOFT_ONENOTE_USER_ID` | Object ID of a user whose notebooks the signed-in user can read |

The live tests use identifiers that exist only in the mock server, so they need the constants at the top of `test.bal` replaced with the identifiers of a notebook, section, section group, page and operation in your account.

```bash
./gradlew clean test -Pgroups=live_tests
```
