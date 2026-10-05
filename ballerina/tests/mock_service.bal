// The service skeleton was generated from the mock OpenAPI specification by the Ballerina OpenAPI tool;
// the response bodies, mock types and data helpers below are hand-written.

// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
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

listener http:Listener ep0 = new (9090);

service / on ep0 {
    # Delete me onenote notebooks
    #
    # + notebookId - The unique identifier of notebook
    # + ifMatch - ETag
    # + return - returns can be any of following types 
    # http:NoContent (Success)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function delete me/onenote/notebooks/[string notebookId](@http:Header {name: "If-Match"} string? ifMatch) returns http:NoContent|ODataErrorBadRequest|ODataErrorInternalServerError {
        return http:NO_CONTENT;
    }

    # Delete page
    #
    # + onenotePageId - The unique identifier of onenotePage
    # + ifMatch - ETag
    # + return - returns can be any of following types 
    # http:NoContent (Success)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function delete me/onenote/pages/[string onenotePageId](@http:Header {name: "If-Match"} string? ifMatch) returns http:NoContent|ODataErrorBadRequest|ODataErrorInternalServerError {
        return http:NO_CONTENT;
    }

    # List notebooks
    #
    # + top - Show only the first n items
    # + skip - Skip the first n items
    # + search - Search items by search phrases
    # + filter - Filter items by property values
    # + count - Include count of items
    # + orderby - Order items by property values
    # + \$select - Select properties to be returned
    # + expand - Expand related entities
    # + return - returns can be any of following types 
    # http:Ok (Retrieved collection)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function get me/onenote/notebooks(@http:Query {name: "$top"} int? top, @http:Query {name: "$skip"} int? skip, @http:Query {name: "$search"} string? search, @http:Query {name: "$filter"} string? filter, @http:Query {name: "$count"} boolean? count, @http:Query {name: "$orderby"} string[]? orderby, @http:Query {name: "$select"} string[]? 'select, @http:Query {name: "$expand"} string[]? expand) returns NotebookCollectionResponse|ODataErrorBadRequest|ODataErrorInternalServerError {
        return <NotebookCollectionResponse>{value: [notebook("1-4f9c1c7e-0a1b-4d32-9d5a-7b0c1e2f3a41", "Project Notes"), notebook("1-8d2e5b9a-6c14-47f0-8a3e-2f1d9c7b6e52", "Meeting Minutes")]};
    }

    # Get notebook
    #
    # + notebookId - The unique identifier of notebook
    # + \$select - Select properties to be returned
    # + expand - Expand related entities
    # + return - returns can be any of following types 
    # http:Ok (The OneNote notebook)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function get me/onenote/notebooks/[string notebookId](@http:Query {name: "$select"} string[]? 'select, @http:Query {name: "$expand"} string[]? expand) returns Notebook|ODataErrorBadRequest|ODataErrorInternalServerError {
        return notebook(notebookId, "Project Notes");
    }

    # List sectionGroups
    #
    # + notebookId - The unique identifier of notebook
    # + top - Show only the first n items
    # + skip - Skip the first n items
    # + search - Search items by search phrases
    # + filter - Filter items by property values
    # + count - Include count of items
    # + orderby - Order items by property values
    # + \$select - Select properties to be returned
    # + expand - Expand related entities
    # + return - returns can be any of following types 
    # http:Ok (Retrieved collection)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function get me/onenote/notebooks/[string notebookId]/sectionGroups(@http:Query {name: "$top"} int? top, @http:Query {name: "$skip"} int? skip, @http:Query {name: "$search"} string? search, @http:Query {name: "$filter"} string? filter, @http:Query {name: "$count"} boolean? count, @http:Query {name: "$orderby"} string[]? orderby, @http:Query {name: "$select"} string[]? 'select, @http:Query {name: "$expand"} string[]? expand) returns SectionGroupCollectionResponse|ODataErrorBadRequest|ODataErrorInternalServerError {
        return <SectionGroupCollectionResponse>{value: [sectionGroup("1-1a2b3c4d-5e6f-4789-9abc-def012345601", "Engineering")]};
    }

    # List sections
    #
    # + notebookId - The unique identifier of notebook
    # + top - Show only the first n items
    # + skip - Skip the first n items
    # + search - Search items by search phrases
    # + filter - Filter items by property values
    # + count - Include count of items
    # + orderby - Order items by property values
    # + \$select - Select properties to be returned
    # + expand - Expand related entities
    # + return - returns can be any of following types 
    # http:Ok (Retrieved collection)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function get me/onenote/notebooks/[string notebookId]/sections(@http:Query {name: "$top"} int? top, @http:Query {name: "$skip"} int? skip, @http:Query {name: "$search"} string? search, @http:Query {name: "$filter"} string? filter, @http:Query {name: "$count"} boolean? count, @http:Query {name: "$orderby"} string[]? orderby, @http:Query {name: "$select"} string[]? 'select, @http:Query {name: "$expand"} string[]? expand) returns OnenoteSectionCollectionResponse|ODataErrorBadRequest|ODataErrorInternalServerError {
        return <OnenoteSectionCollectionResponse>{value: [section("1-7c1d2e3f-4a5b-4c6d-8e7f-90a1b2c3d401", "Quick Notes"), section("1-7c1d2e3f-4a5b-4c6d-8e7f-90a1b2c3d402", "Ideas")]};
    }

    # Get onenoteOperation
    #
    # + onenoteOperationId - The unique identifier of onenoteOperation
    # + \$select - Select properties to be returned
    # + expand - Expand related entities
    # + return - returns can be any of following types 
    # http:Ok (The status of the long-running OneNote operation)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function get me/onenote/operations/[string onenoteOperationId](@http:Query {name: "$select"} string[]? 'select, @http:Query {name: "$expand"} string[]? expand) returns OnenoteOperation|ODataErrorBadRequest|ODataErrorInternalServerError {
        return <OnenoteOperation>{id: onenoteOperationId, status: "Completed", createdDateTime: "2026-02-03T10:15:00Z", lastActionDateTime: "2026-02-03T10:15:42Z", percentComplete: "100", resourceId: "1-4f9c1c7e-0a1b-4d32-9d5a-7b0c1e2f3a41", resourceLocation: "https://graph.microsoft.com/v1.0/me/onenote/notebooks/1-4f9c1c7e-0a1b-4d32-9d5a-7b0c1e2f3a41"};
    }

    # List onenotePages
    #
    # + top - Show only the first n items
    # + skip - Skip the first n items
    # + search - Search items by search phrases
    # + filter - Filter items by property values
    # + count - Include count of items
    # + orderby - Order items by property values
    # + \$select - Select properties to be returned
    # + expand - Expand related entities
    # + return - returns can be any of following types 
    # http:Ok (Retrieved collection)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function get me/onenote/pages(@http:Query {name: "$top"} int? top, @http:Query {name: "$skip"} int? skip, @http:Query {name: "$search"} string? search, @http:Query {name: "$filter"} string? filter, @http:Query {name: "$count"} boolean? count, @http:Query {name: "$orderby"} string[]? orderby, @http:Query {name: "$select"} string[]? 'select, @http:Query {name: "$expand"} string[]? expand) returns OnenotePageCollectionResponse|ODataErrorBadRequest|ODataErrorInternalServerError {
        return <OnenotePageCollectionResponse>{value: [page("1-2b7f3a10-9c4d-4e5f-a6b7-c8d9e0f1a201", "Weekly Sync"), page("1-2b7f3a10-9c4d-4e5f-a6b7-c8d9e0f1a202", "Design Review")]};
    }

    # Get page
    #
    # + onenotePageId - The unique identifier of onenotePage
    # + \$select - Select properties to be returned
    # + expand - Expand related entities
    # + return - returns can be any of following types 
    # http:Ok (The OneNote page)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function get me/onenote/pages/[string onenotePageId](@http:Query {name: "$select"} string[]? 'select, @http:Query {name: "$expand"} string[]? expand) returns OnenotePage|ODataErrorBadRequest|ODataErrorInternalServerError {
        return page(onenotePageId, "Weekly Sync");
    }

    # Get me onenote pages content
    #
    # + onenotePageId - The unique identifier of onenotePage
    # + return - returns can be any of following types 
    # http:Ok (Retrieved media content)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function get me/onenote/pages/[string onenotePageId]/content() returns byte[]|ODataErrorBadRequest|ODataErrorInternalServerError {
        return "<html><head><title>Weekly Sync</title></head><body><p>Agenda for the weekly sync</p></body></html>".toBytes();
    }

    # Get sectionGroup
    #
    # + sectionGroupId - The unique identifier of sectionGroup
    # + \$select - Select properties to be returned
    # + expand - Expand related entities
    # + return - returns can be any of following types 
    # http:Ok (The OneNote section group)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function get me/onenote/sectionGroups/[string sectionGroupId](@http:Query {name: "$select"} string[]? 'select, @http:Query {name: "$expand"} string[]? expand) returns SectionGroup|ODataErrorBadRequest|ODataErrorInternalServerError {
        return sectionGroup(sectionGroupId, "Engineering");
    }

    # List sections
    #
    # + top - Show only the first n items
    # + skip - Skip the first n items
    # + search - Search items by search phrases
    # + filter - Filter items by property values
    # + count - Include count of items
    # + orderby - Order items by property values
    # + \$select - Select properties to be returned
    # + expand - Expand related entities
    # + return - returns can be any of following types 
    # http:Ok (Retrieved collection)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function get me/onenote/sections(@http:Query {name: "$top"} int? top, @http:Query {name: "$skip"} int? skip, @http:Query {name: "$search"} string? search, @http:Query {name: "$filter"} string? filter, @http:Query {name: "$count"} boolean? count, @http:Query {name: "$orderby"} string[]? orderby, @http:Query {name: "$select"} string[]? 'select, @http:Query {name: "$expand"} string[]? expand) returns OnenoteSectionCollectionResponse|ODataErrorBadRequest|ODataErrorInternalServerError {
        return <OnenoteSectionCollectionResponse>{value: [section("1-7c1d2e3f-4a5b-4c6d-8e7f-90a1b2c3d401", "Quick Notes"), section("1-7c1d2e3f-4a5b-4c6d-8e7f-90a1b2c3d402", "Ideas")]};
    }

    # Get section
    #
    # + onenoteSectionId - The unique identifier of onenoteSection
    # + \$select - Select properties to be returned
    # + expand - Expand related entities
    # + return - returns can be any of following types 
    # http:Ok (The OneNote section)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function get me/onenote/sections/[string onenoteSectionId](@http:Query {name: "$select"} string[]? 'select, @http:Query {name: "$expand"} string[]? expand) returns OnenoteSection|ODataErrorBadRequest|ODataErrorInternalServerError {
        return section(onenoteSectionId, "Quick Notes");
    }

    # List pages
    #
    # + onenoteSectionId - The unique identifier of onenoteSection
    # + top - Show only the first n items
    # + skip - Skip the first n items
    # + search - Search items by search phrases
    # + filter - Filter items by property values
    # + count - Include count of items
    # + orderby - Order items by property values
    # + \$select - Select properties to be returned
    # + expand - Expand related entities
    # + return - returns can be any of following types 
    # http:Ok (Retrieved collection)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function get me/onenote/sections/[string onenoteSectionId]/pages(@http:Query {name: "$top"} int? top, @http:Query {name: "$skip"} int? skip, @http:Query {name: "$search"} string? search, @http:Query {name: "$filter"} string? filter, @http:Query {name: "$count"} boolean? count, @http:Query {name: "$orderby"} string[]? orderby, @http:Query {name: "$select"} string[]? 'select, @http:Query {name: "$expand"} string[]? expand) returns OnenotePageCollectionResponse|ODataErrorBadRequest|ODataErrorInternalServerError {
        return <OnenotePageCollectionResponse>{value: [page("1-2b7f3a10-9c4d-4e5f-a6b7-c8d9e0f1a201", "Weekly Sync")]};
    }

    # Get notebooks from users
    #
    # + userId - The unique identifier of user
    # + top - Show only the first n items
    # + skip - Skip the first n items
    # + search - Search items by search phrases
    # + filter - Filter items by property values
    # + count - Include count of items
    # + orderby - Order items by property values
    # + \$select - Select properties to be returned
    # + expand - Expand related entities
    # + return - returns can be any of following types 
    # http:Ok (Retrieved collection)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function get users/[string userId]/onenote/notebooks(@http:Query {name: "$top"} int? top, @http:Query {name: "$skip"} int? skip, @http:Query {name: "$search"} string? search, @http:Query {name: "$filter"} string? filter, @http:Query {name: "$count"} boolean? count, @http:Query {name: "$orderby"} string[]? orderby, @http:Query {name: "$select"} string[]? 'select, @http:Query {name: "$expand"} string[]? expand) returns NotebookCollectionResponse|ODataErrorBadRequest|ODataErrorInternalServerError {
        return <NotebookCollectionResponse>{value: [notebook("1-0e5a7c91-3b2d-4f68-b1a9-6d4c8e2f7a10", "Team Handbook")]};
    }

    # Get notebooks from users
    #
    # + userId - The unique identifier of user
    # + notebookId - The unique identifier of notebook
    # + \$select - Select properties to be returned
    # + expand - Expand related entities
    # + return - returns can be any of following types 
    # http:Ok (The OneNote notebook)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function get users/[string userId]/onenote/notebooks/[string notebookId](@http:Query {name: "$select"} string[]? 'select, @http:Query {name: "$expand"} string[]? expand) returns Notebook|ODataErrorBadRequest|ODataErrorInternalServerError {
        return notebook(notebookId, "Team Handbook");
    }

    # Update me onenote notebooks
    #
    # + notebookId - The unique identifier of notebook
    # + payload - Properties to update on the OneNote notebook 
    # + return - returns can be any of following types 
    # http:Ok (The OneNote notebook)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function patch me/onenote/notebooks/[string notebookId](@http:Payload Notebook payload) returns Notebook|ODataErrorBadRequest|ODataErrorInternalServerError {
        return notebook(notebookId, payload?.displayName ?: "Project Notes");
    }

    # Create notebook
    #
    # + payload - The OneNote notebook to create 
    # + return - returns can be any of following types 
    # http:Ok (The created OneNote notebook)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function post me/onenote/notebooks(@http:Payload Notebook payload) returns NotebookOk|ODataErrorBadRequest|ODataErrorInternalServerError {
        return <NotebookOk>{body: notebook("1-b3c4d5e6-f708-4192-a3b4-c5d6e7f80910", payload?.displayName ?: "New Notebook")};
    }

    # Invoke action copyNotebook
    #
    # + notebookId - The unique identifier of notebook
    # + payload - Action parameters 
    # + return - returns can be any of following types 
    # http:Ok (The status of the long-running OneNote operation)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function post me/onenote/notebooks/[string notebookId]/copyNotebook(@http:Payload CopyNotebookRequest payload) returns OnenoteOperationOk|ODataErrorBadRequest|ODataErrorInternalServerError {
        return <OnenoteOperationOk>{body: copyOperation()};
    }

    # Create sectionGroup
    #
    # + notebookId - The unique identifier of notebook
    # + payload - The OneNote section group to create 
    # + return - returns can be any of following types 
    # http:Ok (The created OneNote section group)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function post me/onenote/notebooks/[string notebookId]/sectionGroups(@http:Payload SectionGroup payload) returns SectionGroupOk|ODataErrorBadRequest|ODataErrorInternalServerError {
        return <SectionGroupOk>{body: sectionGroup("1-c4d5e6f7-0819-42a3-b4c5-d6e7f8091021", payload?.displayName ?: "New Section Group")};
    }

    # Create section
    #
    # + notebookId - The unique identifier of notebook
    # + payload - The OneNote section to create 
    # + return - returns can be any of following types 
    # http:Ok (The created OneNote section)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function post me/onenote/notebooks/[string notebookId]/sections(@http:Payload OnenoteSection payload) returns OnenoteSectionOk|ODataErrorBadRequest|ODataErrorInternalServerError {
        return <OnenoteSectionOk>{body: section("1-d5e6f708-192a-43b4-c5d6-e7f809102132", payload?.displayName ?: "New Section")};
    }

    # Invoke action getNotebookFromWebUrl
    #
    # + payload - Action parameters 
    # + return - returns can be any of following types 
    # http:Ok (The notebook produced by the copy)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function post me/onenote/notebooks/getNotebookFromWebUrl(@http:Payload GetNotebookFromWebUrlRequest payload) returns CopyNotebookModelOk|ODataErrorBadRequest|ODataErrorInternalServerError {
        return <CopyNotebookModelOk>{body: {id: "1-4f9c1c7e-0a1b-4d32-9d5a-7b0c1e2f3a41", name: "Project Notes", isDefault: false, isShared: false, userRole: "Owner", createdTime: "2026-01-12T09:30:00Z", lastModifiedTime: "2026-02-01T14:05:00Z", self: "https://graph.microsoft.com/v1.0/me/onenote/notebooks/1-4f9c1c7e-0a1b-4d32-9d5a-7b0c1e2f3a41"}};
    }

    # Invoke action copyToSection
    #
    # + onenotePageId - The unique identifier of onenotePage
    # + payload - Action parameters 
    # + return - returns can be any of following types 
    # http:Ok (The status of the long-running OneNote operation)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function post me/onenote/pages/[string onenotePageId]/copyToSection(@http:Payload CopyPageToSectionRequest payload) returns OnenoteOperationOk|ODataErrorBadRequest|ODataErrorInternalServerError {
        return <OnenoteOperationOk>{body: copyOperation()};
    }

    # Invoke action onenotePatchContent
    #
    # + onenotePageId - The unique identifier of onenotePage
    # + payload - Action parameters 
    # + return - returns can be any of following types 
    # http:NoContent (Success)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function post me/onenote/pages/[string onenotePageId]/onenotePatchContent(@http:Payload PatchPageContentRequest payload) returns http:NoContent|ODataErrorBadRequest|ODataErrorInternalServerError {
        return http:NO_CONTENT;
    }

    # Create page
    #
    # + onenoteSectionId - The unique identifier of onenoteSection
    # + payload - The OneNote page to create 
    # + return - returns can be any of following types 
    # http:Ok (The created OneNote page)
    # http:BadRequest (error)
    # http:InternalServerError (error)
    resource function post me/onenote/sections/[string onenoteSectionId]/pages(@http:Payload OnenotePage payload) returns OnenotePageOk|ODataErrorBadRequest|ODataErrorInternalServerError {
        return <OnenotePageOk>{body: page("1-e6f70819-2a3b-44c5-d6e7-f8091021324" + "3", payload?.title ?: "New Page")};
    }
}

public type MockODataError record {|
    record {|
        string code;
        string message;
    |} 'error;
|};

public type ODataErrorBadRequest record {|
    *http:BadRequest;
    MockODataError body;
|};

public type ODataErrorInternalServerError record {|
    *http:InternalServerError;
    MockODataError body;
|};

public type NotebookOk record {|
    *http:Ok;
    Notebook body;
|};

public type SectionGroupOk record {|
    *http:Ok;
    SectionGroup body;
|};

public type OnenoteSectionOk record {|
    *http:Ok;
    OnenoteSection body;
|};

public type OnenotePageOk record {|
    *http:Ok;
    OnenotePage body;
|};

public type OnenoteOperationOk record {|
    *http:Ok;
    OnenoteOperation body;
|};

public type CopyNotebookModelOk record {|
    *http:Ok;
    CopyNotebookModel body;
|};

function notebook(string id, string name) returns Notebook => {
    id,
    displayName: name,
    isDefault: false,
    isShared: false,
    userRole: "Owner",
    createdDateTime: "2026-01-12T09:30:00Z",
    lastModifiedDateTime: "2026-02-01T14:05:00Z",
    self: "https://graph.microsoft.com/v1.0/me/onenote/notebooks/" + id,
    sectionsUrl: "https://graph.microsoft.com/v1.0/me/onenote/notebooks/" + id + "/sections",
    sectionGroupsUrl: "https://graph.microsoft.com/v1.0/me/onenote/notebooks/" + id + "/sectionGroups",
    links: {oneNoteWebUrl: {href: "https://contoso.sharepoint.com/personal/user/Notebooks/" + name}}
};

function sectionGroup(string id, string name) returns SectionGroup => {
    id,
    displayName: name,
    createdDateTime: "2026-01-15T08:00:00Z",
    lastModifiedDateTime: "2026-02-02T11:20:00Z",
    self: "https://graph.microsoft.com/v1.0/me/onenote/sectionGroups/" + id,
    sectionsUrl: "https://graph.microsoft.com/v1.0/me/onenote/sectionGroups/" + id + "/sections",
    sectionGroupsUrl: "https://graph.microsoft.com/v1.0/me/onenote/sectionGroups/" + id + "/sectionGroups"
};

function section(string id, string name) returns OnenoteSection => {
    id,
    displayName: name,
    isDefault: false,
    createdDateTime: "2026-01-16T09:10:00Z",
    lastModifiedDateTime: "2026-02-02T16:45:00Z",
    self: "https://graph.microsoft.com/v1.0/me/onenote/sections/" + id,
    pagesUrl: "https://graph.microsoft.com/v1.0/me/onenote/sections/" + id + "/pages"
};

function page(string id, string title) returns OnenotePage => {
    id,
    title,
    createdDateTime: "2026-02-03T10:00:00Z",
    lastModifiedDateTime: "2026-02-03T12:30:00Z",
    self: "https://graph.microsoft.com/v1.0/me/onenote/pages/" + id,
    contentUrl: "https://graph.microsoft.com/v1.0/me/onenote/pages/" + id + "/content",
    level: 0,
    'order: 1
};

function copyOperation() returns OnenoteOperation => {
    id: "1-5a6b7c8d-9e0f-4a1b-8c2d-3e4f5a6b7c8d",
    status: "Running",
    createdDateTime: "2026-02-03T10:15:00Z",
    lastActionDateTime: "2026-02-03T10:15:05Z",
    percentComplete: "25"
};
