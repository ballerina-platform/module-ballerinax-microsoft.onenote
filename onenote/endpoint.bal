// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;

# Ballerina Microsoft OneNote connector provides the capability to access Microsoft Graph OneNote API
# It provides capability to perform perform CRUD (Create, Read, Update, and Delete) operations on [OneNote]
# (https://docs.microsoft.com/en-us/graph/api/resources/onenote-api-overview?view=graph-rest-1.0).
# 
# + httpClient - HTTP Client
@display {
    label: "Microsoft OneNote",
    iconPath: "icon.png"
}
public isolated client class Client {
    private final http:Client httpClient;

    # Initializes the connector. During initialization you can pass either http:BearerTokenConfig if you have a bearer 
    # token or http:OAuth2RefreshTokenGrantConfig if you have OAuth tokens.
    # Create a Microsoft account and obtain tokens following 
    # [this guide](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-v2-protocols)
    # 
    # + config - Configuration required to initialize the client
    # + return - An error if initialization fails
    public isolated function init(ConnectionConfig config) returns error? {
        self.httpClient = check new (BASE_URL, config);
    }

    // Notebooks

    # Creates a notebook.
    # 
    # + noteBookName - Display name for notebook
    # + return - Notebook if successful or else an error
    @display {label: "Create Notebook"}
    remote isolated function createNotebook(@display {label: "Notebook Name"} string noteBookName) returns 
                                            Notebook|error {
        string path = NOTEBOOKS_PATH;
        return check self.httpClient->post(path, {"displayName": noteBookName}, targetType = Notebook);
    }

    # Lists notebooks.
    # 
    # + oDataQuery - Optional. OData Query. Example: "$top=2&$count=true". 
    # For details, refer https://docs.microsoft.com/en-us/graph/query-parameters#odata-system-query-options
    # + return - Notebook[] if successful or else an error
    @display {label: "List Notebooks"}
    remote isolated function listNotebooks(@display {label: "OData Query"} string? oDataQuery = ()) 
                                           returns Notebook[]|error {
        string path = NOTEBOOKS_PATH;
        if (oDataQuery is string) {
            path = path + QUESTION_MARK + oDataQuery;
        }
        http:Response response = check self.httpClient->get(path);
        return getNotebookArray(response);
    }

    # Gets a notebook.
    # 
    # + notebookId - Notebook ID
    # + return - Notebook if successful or else an error
    @display {label: "Get Notebook"}
    remote isolated function getNotebook(@display {label: "Notebook ID"} string notebookId) returns Notebook|error {
        string path = NOTEBOOKS_PATH + SLASH + notebookId;
        return check self.httpClient->get(path, targetType = Notebook);
    }

    # Lists recent notebooks.
    # 
    # + return - RecentNotebook[] if successful or else an error
    @display {label: "Get Recent Notebooks"}
    remote isolated function getRecentNotebooks() returns RecentNotebook[]|error {
        string path = NOTEBOOKS_PATH + "/getRecentNotebooks(includePersonalNotebooks=true)";
        http:Response response = check self.httpClient->get(path);
        return getRecentNotebookArray(response);
    }

    // Sections

    # Lists sections.
    # 
    # + notebookId - Notebook ID
    # + oDataQuery - Optional. OData Query. Example: "$top=2&$count=true". 
    # For details, refer https://docs.microsoft.com/en-us/graph/query-parameters#odata-system-query-options
    # + return - Section[] if successful or else an error
    @display {label: "List Sections"}
    remote isolated function listSections(@display {label: "Notebook ID"} string notebookId, 
                                          @display {label: "OData Query"} string? oDataQuery = ()) returns 
                                          Section[]|error {
        string path = NOTEBOOKS_PATH + SLASH + notebookId + SECTIONS;
        if (oDataQuery is string) {
            path = path + QUESTION_MARK + oDataQuery;
        }
        http:Response response = check self.httpClient->get(path);
        return getSectionArray(response);
    }

    # Gets a section.
    # 
    # + sectionId - Section ID
    # + return - Section if successful or else an error
    @display {label: "Get Section"}
    remote isolated function getSection(@display {label: "Section ID"} string sectionId) returns Section|error {
        string path = SECTIONS_PATH + sectionId;
        return check self.httpClient->get(path, targetType = Section);
    }

    # Creates a section.
    # 
    # + notebookId - Notebook ID
    # + sectionName - Display name for the section
    # + return - Section if successful or else an error
    @display {label: "Create Section"}
    remote isolated function createSection(@display {label: "Notebook ID"} string notebookId, 
                                           @display {label: "Section Name"} string sectionName) returns Section|error {
        string path = NOTEBOOKS_PATH + SLASH + notebookId + SECTIONS;
        return check self.httpClient->post(path, {displayName: sectionName}, targetType = Section);
    }

    // Section Groups

    # Lists section groups.
    # 
    # + notebookId - Notebook ID
    # + oDataQuery - Optional. OData Query. Example: "$top=2&$count=true". 
    # For details, refer https://docs.microsoft.com/en-us/graph/query-parameters#odata-system-query-options
    # + return - SectionGroup[] if successful or else an error
    @display {label: "List Section Groups"}
    remote isolated function listSectionGroups(@display {label: "Notebook ID"} string notebookId, 
                                               @display {label: "OData Query"} string? oDataQuery = ()) returns 
                                               SectionGroup[]|error {
        string path = NOTEBOOKS_PATH + SLASH + notebookId + SECTION_GROUPS;
        if (oDataQuery is string) {
            path = path + QUESTION_MARK + oDataQuery;
        }
        http:Response response = check self.httpClient->get(path);
        return getSectionGroupArray(response);
    }

    # Creates a section group.
    # 
    # + notebookId - Notebook ID
    # + sectionGroupName - Display name for the section
    # + return - Section if successful or else an error
    @display {label: "Create Section Group"}
    remote isolated function createSectionGroup(@display {label: "Notebook ID"} string notebookId, 
                                                @display {label: "Section Group Name"} string sectionGroupName) returns 
                                                SectionGroup|error {
        string path = NOTEBOOKS_PATH + SLASH + notebookId + SECTION_GROUPS;
        return check self.httpClient->post(path, {displayName: sectionGroupName}, targetType = SectionGroup);
    }

    # Gets a section group.
    # 
    # + sectionGroupId - Section group ID
    # + return - Section if successful or else an error
    @display {label: "Get Section Group"}
    remote isolated function getSectionGroup(@display {label: "Section Group ID"} string sectionGroupId) returns 
                                             SectionGroup|error {
        string path = SECTION_GROUP_PATH + sectionGroupId;
        return check self.httpClient->get(path, targetType = SectionGroup);
    }

    # Creates a section in a section group.
    # 
    # + sectionGroupId - Section group ID
    # + sectionName - Display name for the section
    # + return - Section if successful or else an error
    @display {label: "Create Section in SectionGroup"}
    remote isolated function createSectionInSectionGroup(@display {label: "Section Group ID"} string sectionGroupId, 
                                                         @display {label: "Section Name"} string sectionName) returns 
                                                         Section|error {
        string path = SECTION_GROUP_PATH + sectionGroupId + SECTIONS;
        return check self.httpClient->post(path, {displayName: sectionName}, targetType = Section);
    }

    // Pages

    # Lists pages of a section.
    # 
    # + sectionId - Section ID
    # + oDataQuery - Optional. OData Query. Example: "$top=2&$count=true". 
    # For details, refer https://docs.microsoft.com/en-us/graph/query-parameters#odata-system-query-options
    # + return - Page[] if successful or else an error
    @display {label: "List Pages"}
    remote isolated function listPages(@display {label: "Section ID"} string sectionId, 
                                       @display {label: "OData Query"} string? oDataQuery = ()) returns Page[]|error {
        string path = SECTIONS_PATH + sectionId + PAGES;
        if (oDataQuery is string) {
            path = path + QUESTION_MARK + oDataQuery;
        }
        http:Response response = check self.httpClient->get(path);
        return getPagesArray(response);
    }

    # Gets a page.
    # 
    # + pageId - Page ID
    # + return - Page if successful or else an error
    @display {label: "Get Page"}
    remote isolated function getPage(@display {label: "Page ID"} string pageId) returns Page|error {
        string path = PAGES_PATH + pageId;
        return check self.httpClient->get(path, targetType = Page);
    }

    # Creates a page.
    # 
    # + sectionId - Section ID
    # + pageTitle - Page title
    # + pageBody - Page body
    # + return - Page if page creation is successful or else an error
    @display {label: "Create Page"}
    remote isolated function createPage(@display {label: "Section ID"} string sectionId,
                                        @display {label: "Page Title"} string pageTitle,
                                        @display {label: "Page Body"} string pageBody) returns Page|error {
        string path = SECTIONS_PATH + sectionId + PAGES;
        http:Request request = new();
        string htmlContent = createHTMLContent(pageTitle, pageBody);
        request.setTextPayload(htmlContent);
        check request.setContentType("text/html");
        return check self.httpClient->post(path, request, targetType = Page);
    }

    # Creates a page with HTML content.
    # 
    # + sectionId - Section ID
    # + htmlContent - HTML Content
    # + return - Page if page creation is successful or else an error
    @display {label: "Create Page With HTML"}
    remote isolated function createPageWithHTML(@display {label: "Section ID"} string sectionId,
                                                @display {label: "HTML Content"} string htmlContent) returns Page|error {
        string path = SECTIONS_PATH + sectionId + PAGES;
        http:Request request = new();
        request.setTextPayload(htmlContent);
        check request.setContentType("text/html");
        return check self.httpClient->post(path, request, targetType = Page);
    }

    # Deletes a page.
    # 
    # + pageId - Page ID
    # + return - `()` if the page deletion is successful or else an error if failed
    @display {label: "Delete Page"}
    remote isolated function deletePage(@display {label: "Page ID"} string pageId) returns error? {
        string path = PAGES_PATH + pageId;
        http:Response response = check self.httpClient->delete(path);
        _ = check handleResponse(response);
    }
}

# OneNote Connection Configuration
#
@display{label: "Connection Config"} 
public type ConnectionConfig record {|
    # Configurations related to client authentication
    http:BearerTokenConfig|http:OAuth2RefreshTokenGrantConfig auth;
    # The HTTP version understood by the client
    string httpVersion = "1.1";
    # Configurations related to HTTP/1.x protocol
    http:ClientHttp1Settings http1Settings = {};
    # Configurations related to HTTP/2 protocol
    http:ClientHttp2Settings http2Settings = {};
    # The maximum time to wait (in seconds) for a response before closing the connection
    decimal timeout = 60;
    # The choice of setting `forwarded`/`x-forwarded` header
    string forwarded = "disable";
    # Configurations associated with Redirection
    http:FollowRedirects? followRedirects = ();
    # Configurations associated with request pooling
    http:PoolConfiguration? poolConfig = ();
    # HTTP caching related configurations
    http:CacheConfig cache = {};
    # Specifies the way of handling compression (`accept-encoding`) header
    http:Compression compression = http:COMPRESSION_AUTO;
    # Configurations associated with the behaviour of the Circuit Breaker
    http:CircuitBreakerConfig? circuitBreaker = ();
    # Configurations associated with retrying
    http:RetryConfig? retryConfig = ();
    # Configurations associated with cookies
    http:CookieConfig? cookieConfig = ();
    # Configurations associated with inbound response size limits
    http:ResponseLimitConfigs responseLimits = {};
    #SSL/TLS-related options
    http:ClientSecureSocket? secureSocket = ();
|};
