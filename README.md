Ballerina Connector For Microsoft OneNote
===================

[![Build Status](https://github.com/ballerina-platform/module-ballerinax-microsoft.onenote/workflows/CI/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-msgraph-onedrive/actions?query=workflow%3ACI)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-microsoft.onenote.svg)](https://github.com/ballerina-platform/module-ballerinax-microsoft.onenote/commits/main)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

The `microsoft.onenote` is a [Ballerina](https://ballerina.io/) connector for Microsoft OneNote.

[Microsoft OneNote](https://www.microsoft.com/en-ww/microsoft-365/onenote/digital-note-taking-app) is a cross-functional notebook for all notetaking needs developed by Microsoft in the Office365.

This connector provides operations for connecting and interacting with Microsoft Graph API OneNote endpoints over the network and access a user's OneNote notebooks, sections, and pages in a personal account.

For more information about configuration and operations, go to the module. 
- [`ballerinax/microsoft.onenote`](onenote/Module.md)

## Building from the source
### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 11. You can install either [OpenJDK](https://adoptopenjdk.net/) or [Oracle JDK](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html).

        > **Note:** Set the JAVA_HOME environment variable to the path name of the directory into which you installed JDK.

2. Download and install [Ballerina Swan Lake Beta3](https://ballerina.io/). 

### Building the source
Execute the commands below to build from the source.

* To build the package:
    ```    
    bal build -c ./onenote
    ```
* To build the package without tests:
    ```
    bal build -c --skip-tests ./onenote
    ```
## Contributing to Ballerina
As an open source project, Ballerina welcomes contributions from the community. 

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/main/CONTRIBUTING.md).

## Code of conduct
All contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links
* Discuss about code changes of the Ballerina project in [ballerina-dev@googlegroups.com](mailto:ballerina-dev@googlegroups.com).
* Chat live with us via our [Slack channel](https://ballerina.io/community/slack/).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
