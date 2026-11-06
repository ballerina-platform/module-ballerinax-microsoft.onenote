# Notebook workspace setup

This example sets up a OneNote workspace for a project. It reuses the notebook when one with the given name already exists (or creates it), adds a section group to it, creates a section inside that section group, and lists the section group's sections.

## Prerequisites

### 1. Register a Microsoft Entra application

Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-microsoft.onenote/blob/main/ballerina/README.md#setup-guide) to obtain a client ID, client secret and refresh token. The application needs the `Notes.ReadWrite` and `offline_access` delegated permissions.

### 2. Configuration

Create a `Config.toml` file in this example's directory with the following content:

```toml
clientId = "<client-id>"
clientSecret = "<client-secret>"
refreshToken = "<refresh-token>"
refreshUrl = "https://login.microsoftonline.com/common/oauth2/v2.0/token"
notebookName = "<notebook-name>"
sectionGroupName = "<section-group-name>"
sectionName = "<section-name>"
```

Each run creates a new section group and section, so use new names when you run the example again.

## Run the example

Execute the following command to run the example:

```bash
bal run
```
