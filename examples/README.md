# Examples

The `ballerinax/microsoft.onenote` connector provides practical examples illustrating usage in various scenarios.

1. **[Notebook workspace setup](https://github.com/ballerina-platform/module-ballerinax-microsoft.onenote/tree/main/examples/notebook_workspace_setup)** - Find or create a notebook, then add a section group with a section inside it and list the section group's sections.

2. **[Page content export](https://github.com/ballerina-platform/module-ballerinax-microsoft.onenote/tree/main/examples/page_content_export)** - Walk a section page by page, report each page's HTML content and optionally copy the pages into another section.

## Prerequisites

1. Register a Microsoft Entra application and obtain a refresh token as described in the [Setup guide](https://central.ballerina.io/ballerinax/microsoft.onenote/latest#setup-guide).

2. For each example, create a `Config.toml` file with the related configuration. Here's an example of how your Config.toml file should look:

```toml
clientId = "<client-id>"
clientSecret = "<client-secret>"
refreshToken = "<refresh-token>"
refreshUrl = "https://login.microsoftonline.com/common/oauth2/v2.0/token"
```

Each example lists the additional values it needs in its own README.

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
