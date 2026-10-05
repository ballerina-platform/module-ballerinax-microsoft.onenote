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

// Sets up a OneNote workspace for a project: finds or creates the notebook, then adds a section
// group and a section to it, and lists the sections the notebook now holds.

import ballerina/io;
import ballerinax/microsoft.onenote;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string notebookName = ?;
configurable string sectionGroupName = ?;
configurable string sectionName = ?;

public function main() returns error? {
    onenote:Client onenote = check new ({
        auth: {clientId, clientSecret, refreshToken, refreshUrl}
    });

    // Reuse the notebook when it already exists so that re-running does not create duplicates.
    onenote:NotebookCollectionResponse notebooks = check onenote->listNotebooks(
        filter = string `displayName eq '${notebookName}'`);
    onenote:Notebook[] existing = notebooks?.value ?: [];
    onenote:Notebook notebook;
    if existing.length() > 0 {
        notebook = existing[0];
    } else {
        notebook = check onenote->createNotebook({displayName: notebookName});
    }
    string notebookId = notebook?.id ?: "";
    if notebookId == "" {
        return error("The notebook has no identifier");
    }
    io:println("Notebook: ", notebook?.displayName, " (", notebookId, ")");

    onenote:SectionGroup sectionGroup = check onenote->createNotebookSectionGroup(
        notebookId, {displayName: sectionGroupName});
    io:println("Section group created: ", sectionGroup?.displayName);

    onenote:OnenoteSection section = check onenote->createNotebookSection(
        notebookId, {displayName: sectionName});
    io:println("Section created: ", section?.displayName);

    onenote:OnenoteSectionCollectionResponse sections = check onenote->listNotebookSections(notebookId);
    foreach onenote:OnenoteSection item in sections?.value ?: [] {
        io:println("Section in notebook: ", item?.displayName);
    }
}
