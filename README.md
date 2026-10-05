# Ballerina Microsoft OneNote connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-microsoft.onenote/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-microsoft.onenote/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-microsoft.onenote.svg)](https://github.com/ballerina-platform/module-ballerinax-microsoft.onenote/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/microsoft.onenote.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Fmicrosoft.onenote)

## Overview

[Microsoft OneNote](https://learn.microsoft.com/en-us/graph/integrate-with-onenote) is the digital note-taking application of Microsoft 365. Through Microsoft Graph it exposes users' notebooks, section groups, sections and pages, together with the page content and the resources embedded in it.

The Microsoft OneNote connector lets Ballerina applications manage the notebooks of the signed-in user and of other users in the organization, organize them into section groups and sections, read and update page content, and copy notebooks, sections and pages. It supports version 1.0 of the Microsoft Graph REST API.

## Setup guide

To use the Microsoft OneNote connector, you need a Microsoft 365 or Outlook.com account and an application registered in Microsoft Entra ID with OAuth 2.0 credentials.

### Step 1: Sign in to the Azure portal

1. If you don't have a Microsoft Azure account, you can create one for free at [https://azure.microsoft.com](https://azure.microsoft.com).

2. Go to the [Azure portal](https://portal.azure.com) and sign in. From the home page, navigate to **Microsoft Entra ID**.

### Step 2: Register an application

1. In the Microsoft Entra admin center, navigate to **App registrations** from the left sidebar.

2. Click **New registration**.

3. Enter a name for the application, for example `Ballerina OneNote Connector`. Under **Supported account types**, choose the accounts that will sign in: accounts in your organization only, or any organization and personal Microsoft accounts if Outlook.com users must be able to sign in.

4. Under **Redirect URI**, select **Web** and enter the URI that receives the authorization code, for example `http://localhost`. Then click **Register**.

### Step 3: Add API permissions

1. In the registered application, navigate to **API permissions** and click **Add a permission**.

2. Select **Microsoft Graph**, then **Delegated permissions**, and add the following permissions:

   - `Notes.ReadWrite` to read and write the signed-in user's notebooks
   - `Notes.Create` to create notebooks, sections and pages in the signed-in user's account
   - `Notes.ReadWrite.All` to read and write notebooks that other users have shared with the signed-in user (needed for the operations under `users/{userId}`)
   - `offline_access` so that the token response includes a refresh token

3. Click **Add permissions**. If your organization requires it, ask an administrator to grant consent.

### Step 4: Create a client secret

1. Navigate to **Overview** in the registered application and copy the **Application (client) ID**. This is your `clientId`.

2. Navigate to **Certificates & secrets** > **Client secrets** > **New client secret**.

3. Enter a description, choose an expiry period and click **Add**. Copy the secret **Value** immediately. This is your `clientSecret`.

### Step 5: Obtain a refresh token

1. Open the following URL in a browser, replacing `<CLIENT_ID>` and `<REDIRECT_URI>` with your values, and sign in with the account whose notebooks the connector will use:

   ```text
   https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=<CLIENT_ID>&response_type=code&redirect_uri=<REDIRECT_URI>&response_mode=query&scope=Notes.ReadWrite%20Notes.Create%20Notes.ReadWrite.All%20offline_access
   ```

2. After you grant consent, the browser is redirected to your redirect URI with a `code` query parameter. Copy its value.

3. Exchange the code for tokens:

   ```bash
   curl --location 'https://login.microsoftonline.com/common/oauth2/v2.0/token' \
   --header 'Content-Type: application/x-www-form-urlencoded' \
   --data-urlencode 'grant_type=authorization_code' \
   --data-urlencode 'code=<CODE>' \
   --data-urlencode 'redirect_uri=<REDIRECT_URI>' \
   --data-urlencode 'client_id=<CLIENT_ID>' \
   --data-urlencode 'client_secret=<CLIENT_SECRET>' \
   --data-urlencode 'scope=Notes.ReadWrite Notes.Create Notes.ReadWrite.All offline_access'
   ```

4. Store the `refresh_token` from the response securely. Use `https://login.microsoftonline.com/common/oauth2/v2.0/token` as the refresh URL. If the application is registered for your organization only, replace `common` with your tenant ID in both URLs.

OneNote in Microsoft Graph no longer supports application-only access, so every operation needs a signed-in user.

## Quickstart

To use the Microsoft OneNote connector in your Ballerina application, update your `.bal` file as follows.

### Step 1: Import the module

Import the `microsoft.onenote` module.

```ballerina
import ballerinax/microsoft.onenote;
```

### Step 2: Configure the credentials

Create a `Config.toml` file with the credentials obtained in the setup guide:

```toml
clientId = "<CLIENT_ID>"
clientSecret = "<CLIENT_SECRET>"
refreshToken = "<REFRESH_TOKEN>"
refreshUrl = "https://login.microsoftonline.com/common/oauth2/v2.0/token"
```

### Step 3: Instantiate a new connector

Initialize the client with the refresh token grant configuration.

```ballerina
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;

final onenote:Client onenoteClient = check new ({
    auth: {clientId, clientSecret, refreshToken, refreshUrl}
});
```

### Step 4: Invoke the connector operation

Use the connector operations. The following creates a notebook in the signed-in user's account.

```ballerina
public function main() returns error? {
    onenote:Notebook _ = check onenoteClient->createNotebook({displayName: "Project Notes"});
}
```

## Examples

The Microsoft OneNote connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-microsoft.onenote/tree/main/examples/), covering the following use cases:

1. [Notebook workspace setup](examples/notebook_workspace_setup/notebook_workspace_setup.md) - Find or create a notebook, then add a section group and a section to it and list the notebook's sections.
2. [Page content export](examples/page_content_export/page_content_export.md) - Walk a section page by page, report each page's HTML content and optionally copy the pages into another section.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`microsoft.onenote` package](https://central.ballerina.io/ballerinax/microsoft.onenote/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
