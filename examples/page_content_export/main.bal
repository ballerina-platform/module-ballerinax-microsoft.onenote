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

// Walks one notebook section page by page, prints the title and size of each page's HTML content,
// and optionally copies the pages into another section.

import ballerina/io;
import ballerinax/microsoft.onenote;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string notebookName = ?;
configurable string sectionName = ?;
configurable int pageSize = 20;
// Copying creates pages in the target section, so it is off unless enabled.
configurable boolean copyPages = false;
configurable string targetSectionId = "";

public function main() returns error? {
    // Microsoft Graph returns at most 100 pages per request; a zero or negative size would never advance.
    if pageSize < 1 || pageSize > 100 {
        return error(string `pageSize must be between 1 and 100, but was ${pageSize}`);
    }

    onenote:Client onenote = check new ({
        auth: {clientId, clientSecret, refreshToken, refreshUrl}
    });

    onenote:NotebookCollectionResponse notebooks = check onenote->listNotebooks(
        filter = string `displayName eq '${escapeODataString(notebookName)}'`);
    onenote:Notebook[] matches = notebooks?.value ?: [];
    if matches.length() == 0 {
        return error(string `Notebook '${notebookName}' was not found`);
    }
    string notebookId = matches[0]?.id ?: "";

    onenote:OnenoteSectionCollectionResponse sections = check onenote->listNotebookSections(
        notebookId, filter = string `displayName eq '${escapeODataString(sectionName)}'`);
    onenote:OnenoteSection[] sectionMatches = sections?.value ?: [];
    if sectionMatches.length() == 0 {
        return error(string `Section '${sectionName}' was not found in the notebook`);
    }
    string sectionId = sectionMatches[0]?.id ?: "";

    int skip = 0;
    int total = 0;
    while true {
        onenote:OnenotePageCollectionResponse page = check onenote->listSectionPages(
            sectionId, top = pageSize, skip = skip);
        onenote:OnenotePage[] pages = page?.value ?: [];
        foreach onenote:OnenotePage item in pages {
            string pageId = item?.id ?: "";
            byte[] content = check onenote->getPageContent(pageId);
            io:println(item?.title, ": ", content.length(), " bytes of HTML");
            if copyPages {
                if targetSectionId == "" {
                    return error("targetSectionId is required when copyPages is enabled");
                }
                onenote:OnenoteOperation operation = check onenote->copyPageToSection(pageId, {id: targetSectionId});
                io:println("Copy started: ", operation?.id);
            }
            total += 1;
        }
        if pages.length() < pageSize {
            break;
        }
        skip += pageSize;
    }
    io:println("Pages processed: ", total);
}

// Doubles each apostrophe so that the value is a valid OData string literal.
function escapeODataString(string value) returns string => re `'`.replaceAll(value, "''");
