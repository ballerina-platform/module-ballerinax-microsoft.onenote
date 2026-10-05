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

import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://graph.microsoft.com/v1.0" : "http://localhost:9090";
final string accessToken = isLiveServer ? os:getEnv("MICROSOFT_ONENOTE_ACCESS_TOKEN") : "test_token";
final string testUserId = isLiveServer ? os:getEnv("MICROSOFT_ONENOTE_USER_ID") : "user-1";

final Client onenote = check new ({
    auth: {token: accessToken},
    httpVersion: isLiveServer ? "2.0" : "1.1"
}, serviceUrl);

const string NOTEBOOK_ID = "1-4f9c1c7e-0a1b-4d32-9d5a-7b0c1e2f3a41";
const string SECTION_ID = "1-7c1d2e3f-4a5b-4c6d-8e7f-90a1b2c3d401";
const string SECTION_GROUP_ID = "1-1a2b3c4d-5e6f-4789-9abc-def012345601";
const string PAGE_ID = "1-2b7f3a10-9c4d-4e5f-a6b7-c8d9e0f1a201";
const string OPERATION_ID = "1-5a6b7c8d-9e0f-4a1b-8c2d-3e4f5a6b7c8d";

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCopyNotebook() returns error? {
    OnenoteOperation response = check onenote->copyNotebook(NOTEBOOK_ID, {renameAs: "Notebook Copy"});
    test:assertTrue(response?.id !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCopyPageToSection() returns error? {
    OnenoteOperation response = check onenote->copyPageToSection(PAGE_ID, {id: SECTION_ID});
    test:assertTrue(response?.id !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreateNotebook() returns error? {
    Notebook response = check onenote->createNotebook({displayName: "Test Notebook"});
    test:assertTrue(response?.id !is ());
    test:assertEquals(response?.displayName, "Test Notebook");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreateNotebookSection() returns error? {
    OnenoteSection response = check onenote->createNotebookSection(NOTEBOOK_ID, {displayName: "Test Section"});
    test:assertTrue(response?.id !is ());
    test:assertEquals(response?.displayName, "Test Section");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreateNotebookSectionGroup() returns error? {
    SectionGroup response = check onenote->createNotebookSectionGroup(NOTEBOOK_ID, {displayName: "Test Group"});
    test:assertTrue(response?.id !is ());
    test:assertEquals(response?.displayName, "Test Group");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreateSectionPage() returns error? {
    OnenotePage response = check onenote->createSectionPage(SECTION_ID, {title: "Test Page"});
    test:assertTrue(response?.id !is ());
    test:assertEquals(response?.title, "Test Page");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testDeleteNotebook() returns error? {
    Notebook created = check onenote->createNotebook({displayName: "Notebook To Delete"});
    string notebookId = <string>created?.id;
    check onenote->deleteNotebook(notebookId);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testDeletePage() returns error? {
    OnenotePage created = check onenote->createSectionPage(SECTION_ID, {title: "Page To Delete"});
    string pageId = <string>created?.id;
    check onenote->deletePage(pageId);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetNotebook() returns error? {
    Notebook response = check onenote->getNotebook(NOTEBOOK_ID);
    test:assertEquals(response?.id, NOTEBOOK_ID);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetNotebookFromWebUrl() returns error? {
    CopyNotebookModel response = check onenote->getNotebookFromWebUrl({webUrl: "https://contoso.sharepoint.com/personal/user/Notebooks/Project Notes"});
    test:assertTrue(response?.id !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetOperation() returns error? {
    OnenoteOperation response = check onenote->getOperation(OPERATION_ID);
    test:assertEquals(response?.id, OPERATION_ID);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetPage() returns error? {
    OnenotePage response = check onenote->getPage(PAGE_ID);
    test:assertEquals(response?.id, PAGE_ID);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetPageContent() returns error? {
    byte[] response = check onenote->getPageContent(PAGE_ID);
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetSection() returns error? {
    OnenoteSection response = check onenote->getSection(SECTION_ID);
    test:assertEquals(response?.id, SECTION_ID);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetSectionGroup() returns error? {
    SectionGroup response = check onenote->getSectionGroup(SECTION_GROUP_ID);
    test:assertEquals(response?.id, SECTION_GROUP_ID);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetUserNotebook() returns error? {
    Notebook response = check onenote->getUserNotebook(testUserId, NOTEBOOK_ID);
    test:assertEquals(response?.id, NOTEBOOK_ID);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListNotebookSectionGroups() returns error? {
    SectionGroupCollectionResponse response = check onenote->listNotebookSectionGroups(NOTEBOOK_ID);
    test:assertTrue((response?.value ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListNotebookSections() returns error? {
    OnenoteSectionCollectionResponse response = check onenote->listNotebookSections(NOTEBOOK_ID);
    test:assertTrue((response?.value ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListNotebooks() returns error? {
    NotebookCollectionResponse response = check onenote->listNotebooks();
    test:assertTrue((response?.value ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListPages() returns error? {
    OnenotePageCollectionResponse response = check onenote->listPages();
    test:assertTrue((response?.value ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListSectionPages() returns error? {
    OnenotePageCollectionResponse response = check onenote->listSectionPages(SECTION_ID);
    test:assertTrue((response?.value ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListSections() returns error? {
    OnenoteSectionCollectionResponse response = check onenote->listSections();
    test:assertTrue((response?.value ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListUserNotebooks() returns error? {
    NotebookCollectionResponse response = check onenote->listUserNotebooks(testUserId);
    test:assertTrue((response?.value ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testPatchPageContent() returns error? {
    check onenote->patchPageContent(PAGE_ID, {commands: [<OnenotePatchContentCommand>{action: "Append", target: "body", content: "<p>Added paragraph</p>"}]});
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testUpdateNotebook() returns error? {
    Notebook response = check onenote->updateNotebook(NOTEBOOK_ID, {displayName: "Renamed Notebook"});
    test:assertEquals(response?.displayName, "Renamed Notebook");
}
