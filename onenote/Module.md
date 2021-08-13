## Overview
Ballerina connector for Microsoft OneNote connects the [Microsoft OneNote API](https://docs.microsoft.com/en-us/graph/api/resources/onenote-api-overview?view=graph-rest-1.0) through Ballerina. It provides the capability to perform CRUD operations on OneNote notebooks, sections and pages.

This module supports [Microsoft Graph API](https://docs.microsoft.com/en-us/graph/overview) v1.0 version and only allows to perform functions behalf of the currently logged in user.

## Prerequisites
Before using this connector in your Ballerina application, complete the following:
- Create a [Microsoft Office365 account](https://signup.live.com/)
- Obtain tokens - Follow [this link](https://docs.microsoft.com/en-us/graph/auth-v2-user#authentication-and-authorization-steps)

## Quickstart

To use the MS OneNote connector in your Ballerina application, update the .bal file as follows:

### Step 1: Import connector
First, import the `ballerinax/microsoft.onenote` module as shown below.
```ballerina
import ballerinax/microsoft.onenote;
```

### Step 2: Create a new connector instance
Create a `microsoft.onenote:Configuration` with the OAuth2 tokens obtained and initialize the connector with it.
```ballerina
microsoft.onenote:Configuration configuration = {
    authConfig: {
        refreshUrl: <REFRESH_URL>,
        refreshToken : <REFRESH_TOKEN>,
        clientId : <CLIENT_ID>,
        clientSecret : <CLIENT_SECRET>
    }
};

microsoft.onenote:Client oneNoteClient = check new(configuration);
```

### Step 3: Invoke connector operation
Now you can use the operations available within the connector. Note that they are in the form of remote operations.

Following is an example on how to create a notebook using the connector.

```ballerina
public function main() returns error? {
    Notebook notebook = check oneNoteClient->createNotebook("test");
}
```

**[You can find a list of samples here](https://github.com/ballerina-platform/module-ballerinax-microsoft.onenote/tree/main/samples)**
