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

import ballerina/log;
import ballerina/os;
import ballerina/test;
import ballerina/lang.runtime;

configurable string refreshUrl = os:getEnv("REFRESH_URL");
configurable string refreshToken = os:getEnv("REFRESH_TOKEN");
configurable string clientId = os:getEnv("CLIENT_ID");
configurable string clientSecret = os:getEnv("CLIENT_SECRET");

ConnectionConfig configuration = {
    auth: {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        refreshUrl: refreshUrl
    }
};

Client oneNoteClient = check new(configuration);
string testNotebookName = "My Notebook";
string testSectionName = "Quick Notes";
string testPageTitle = "Test Page Title";
string testSectionGroupName = "Test Section Group";
string notebookId = "1-8ad0487a-f612-4368-9be6-d863712f9254";
string sectionId = EMPTY_STRING;
string sectionGroupId = EMPTY_STRING;
string pageId = EMPTY_STRING;
string pageId2 = EMPTY_STRING;
string pageId3 = EMPTY_STRING;

@test:Config {
    enable: true
}
function testListNotebooks() returns error? {
    log:printInfo("oneNoteClient->listNotebooks()");
    Notebook[] notebooks = check oneNoteClient->listNotebooks();
    log:printInfo("Number of notebooks available: " + notebooks.length().toString());
    log:printInfo("Name of test notebook: " + notebooks[0].displayName);
    test:assertEquals(notebookId, notebooks[0].id);
}

@test:Config {
    enable: true
}
function testListNotebooksWithQuery() returns error? {
    log:printInfo("oneNoteClient->testListNotebooksWithQuery()");
    Notebook[] notebooks = check oneNoteClient->listNotebooks("$top=2&$count=true");
    log:printInfo("Number of notebooks available: " + notebooks.length().toString());
    test:assertEquals(notebookId, notebooks[0].id);
}

@test:Config {
    enable: true,
    dependsOn: [testListNotebooks]
}
function testGetNotebook() returns error? {
    log:printInfo("oneNoteClient->getNotebook()");
    Notebook notebook = check oneNoteClient->getNotebook(notebookId);
    log:printInfo("Notebook name: " + notebook.displayName);
    test:assertEquals(testNotebookName, notebook.displayName);
}

@test:Config {
    enable: true
}
function testGetRecentNotebooks() returns error? {
    log:printInfo("oneNoteClient->getRecentNotebooks()");
    RecentNotebook[] recentNotebooks = check oneNoteClient->getRecentNotebooks();
    log:printInfo("Number of notebooks: " + recentNotebooks.length().toString());
    log:printInfo("Display name of test notebook: " + recentNotebooks[0].displayName);
    test:assertEquals(testNotebookName, recentNotebooks[0].displayName);
}

@test:Config {
    enable: true,
    dependsOn: [testListNotebooks]
}
function testListSections() returns error? {
    log:printInfo("oneNoteClient->testListSections()");
    Section[] sections = check oneNoteClient->listSections(notebookId);
    log:printInfo("No of sections in notebook " + notebookId + " -> " + sections.length().toString());
    log:printInfo("Display name of test section: " + sections[0].displayName);
    sectionId = sections[0].id;
    test:assertEquals(testSectionName, sections[0].displayName);
}

@test:Config {
    enable: true,
    dependsOn: [testListNotebooks]
}
function testListSectionsWithQuery() returns error? {
    log:printInfo("oneNoteClient->testListSectionsWithQuery()");
    Section[] sections = check oneNoteClient->listSections(notebookId, "$top=2&$count=true");
    log:printInfo("No of sections in notebook " + notebookId + " -> " + sections.length().toString());
    test:assertEquals(testSectionName, sections[0].displayName);
}

@test:Config {
    enable: true,
    dependsOn: [testListSections]
}
function testGetSection() returns error? {
    log:printInfo("oneNoteClient->testGetSection()");
    Section section = check oneNoteClient->getSection(sectionId);
    log:printInfo("Name of the section: " + section.displayName);
    test:assertEquals(sectionId, section.id);
}

@test:Config {
    enable: false,
    dependsOn: [testListSections]
}
function testCreateSection() returns error? {
    log:printInfo("oneNoteClient->testCreateSection()");
    Section section = check oneNoteClient->createSection("0-4158FCD360E478B!432", "testSection");
    log:printInfo("Name of the created section: " + section.displayName);
    test:assertEquals("testSection", section.displayName);
}

@test:Config {
    enable: true,
    dependsOn: [testListSections]
}
function testListSectionGroups() returns error? {
    log:printInfo("oneNoteClient->testListSectionGroups()");
    SectionGroup[] sectionGroup = check oneNoteClient->listSectionGroups(notebookId);
    log:printInfo("No of section groups: " + sectionGroup.length().toString());
    log:printInfo("Display name of test section group: " + sectionGroup[0].displayName);
    sectionGroupId = sectionGroup[0].id;
    test:assertEquals(testSectionGroupName, sectionGroup[0].displayName);
}

@test:Config {
    enable: true,
    dependsOn: [testListSections]
}
function testListSectionGroupsWithQuery() returns error? {
    log:printInfo("oneNoteClient->testListSectionGroupsWithQuery()");
    SectionGroup[] sectionGroup = check oneNoteClient->listSectionGroups(notebookId, "$top=2&$count=true");
    log:printInfo("No of section groups: " + sectionGroup.length().toString());
    test:assertEquals(testSectionGroupName, sectionGroup[0].displayName);
}

@test:Config {
    enable: false
}
function testCreateNotebook() returns error? {
    log:printInfo("oneNoteClient->createNotebook()");
    string name = "testNotebook1";
    Notebook notebook = check oneNoteClient->createNotebook(name);
    log:printInfo("Created Notebook name: " + notebook.displayName + " Id: " + notebook.id);
    test:assertEquals(name, notebook.displayName);
}

@test:Config {
    enable: false,
    dependsOn: [testListNotebooks]
}
function testCreateSectionGroup() returns error? {
    log:printInfo("oneNoteClient->testCreateSectionGroup()");
    string name = "testSectionGroup";
    SectionGroup sectionGroup = check oneNoteClient->createSectionGroup(notebookId, name);
    log:printInfo("Created section group: " + sectionGroup.displayName);
    test:assertEquals(name, sectionGroup.displayName);
}

@test:Config {
    enable: false,
    dependsOn: [testListSectionGroups]
}
function testCreateSectionInSectionGroup() returns error? {
    log:printInfo("oneNoteClient->testCreateSectionInSectionGroup()");
    string name = "section2";
    Section section = check oneNoteClient->createSectionInSectionGroup(sectionGroupId, "section2");
    log:printInfo("Created section: " + section.displayName);
    test:assertEquals(name, section.displayName);
}

@test:Config {
    enable: true,
    dependsOn: [testListSectionGroups]
}
function getSectionGroup() returns error? {
    log:printInfo("oneNoteClient->getSectionGroup()");
    SectionGroup sectionGroup = check oneNoteClient->getSectionGroup(sectionGroupId);
    log:printInfo("Section group name: " + sectionGroup.displayName);
    test:assertEquals(sectionGroupId, sectionGroup.id);
}

@test:Config {
    enable: true,
    dependsOn: [testListSections, testDeletePage]
}
function testListPages() returns error? {
    log:printInfo("oneNoteClient->testListPages()");
    runtime:sleep(5);
    Page[] pages = check oneNoteClient->listPages(sectionId);
    log:printInfo("No of pages: " + pages.length().toString());
    boolean testPageFound = false;
    foreach Page page in pages {
        log:printInfo("Title: " + page.title);
        if (page.title == testPageTitle) {
            testPageFound = true;
            pageId = page.id;
        }
    }
    test:assertTrue(testPageFound);
}

@test:Config {
    enable: true,
    dependsOn: [testListSections, testListPages]
}
function testListPagesWithQuery() returns error? {
    log:printInfo("oneNoteClient->testListPagesWithQuery()");
    Page[] pages = check oneNoteClient->listPages(sectionId, "$top=5&$count=true");
    log:printInfo("No of pages: " + pages.length().toString());
    boolean testPageFound = false;
    foreach Page page in pages {
        log:printInfo(page.title);
        if (page.title == testPageTitle) {
            testPageFound = true;
        }
    }
    test:assertTrue(testPageFound);
}

@test:Config {
    enable: true,
    dependsOn: [testListPages]
}
function testGetPage() returns error? {
    log:printInfo("oneNoteClient->testGetPage()");
    Page page = check oneNoteClient->getPage(pageId);
    log:printInfo("Page title: " + page.title);
    test:assertEquals(testPageTitle, page.title);
}

@test:Config {
    enable: true,
    dependsOn: [testListSections]
}
function testCreatePageWithHTML() returns error? {
    log:printInfo("oneNoteClient->testCreatePageWithHTML()");
    string testHtmlContent = "<!DOCTYPE html><html><head><title>Test Page Title</title></head><body><p>Hello</p></body></html>";
    Page page = check oneNoteClient->createPageWithHTML(sectionId, testHtmlContent);
    log:printInfo("Created page title: " + page.title);
    pageId2 = page.id;
    test:assertEquals("Test Page Title", page.title);
}

@test:Config {
    enable: true,
    dependsOn: [testCreatePageWithHTML]
}
function testDeleteHTMLPage() returns error? {
    log:printInfo("oneNoteClient->testDeleteHTMLPage()");
    runtime:sleep(5);
    error? response = oneNoteClient->deletePage(pageId2);
    if (response is error) {
        test:assertFail("Error in deleting page: " + pageId2 + response.toString());
    }
}

@test:Config {
    enable: true,
    dependsOn: [testDeleteHTMLPage]
}
function testCreatePage() returns error? {
    log:printInfo("oneNoteClient->testCreatePage()");
    Page page = check oneNoteClient->createPage(sectionId, pageTitle = "Test Page2 Title", pageBody = "Hi");
    log:printInfo("Created page title: " + page.title);
    pageId3 = page.id;
    test:assertEquals("Test Page2 Title", page.title);
}

@test:Config {
    enable: true,
    dependsOn: [testCreatePage]
}
function testDeletePage() returns error? {
    log:printInfo("oneNoteClient->testDeletePage()");
    runtime:sleep(5);
    error? response = oneNoteClient->deletePage(pageId3);
    if (response is error) {
        test:assertFail("Error in deleting page: " + pageId3 + response.toString());
    }
}
