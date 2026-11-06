# Page content export

This example walks one section of a notebook page by page, prints the title and HTML size of every page, and can optionally copy the pages into another section.

## Prerequisites

### 1. Register a Microsoft Entra application

Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-microsoft.onenote/blob/main/ballerina/README.md#setup-guide) to obtain a client ID, client secret and refresh token. The application needs the `Notes.Read` and `offline_access` delegated permissions, plus `Notes.ReadWrite` when `copyPages` is enabled.

### 2. Configuration

Create a `Config.toml` file in this example's directory with the following content:

```toml
clientId = "<client-id>"
clientSecret = "<client-secret>"
refreshToken = "<refresh-token>"
refreshUrl = "https://login.microsoftonline.com/common/oauth2/v2.0/token"
notebookName = "<notebook-name>"
sectionName = "<section-name>"
pageSize = 20
copyPages = false
targetSectionId = "<target-section-id>"
```

Copying creates pages in the target section, so the example only copies when `copyPages` is `true`. `targetSectionId` is needed only in that case.

## Run the example

Execute the following command to run the example:

```bash
bal run
```
