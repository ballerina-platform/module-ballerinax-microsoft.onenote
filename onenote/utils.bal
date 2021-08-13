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

isolated function handleResponse(http:Response httpResponse) returns map<json>|error {
    if (httpResponse.statusCode == http:STATUS_OK || httpResponse.statusCode == http:STATUS_CREATED) {
        json jsonResponse = check httpResponse.getJsonPayload();
        return <map<json>>jsonResponse;
    } else if (httpResponse.statusCode == http:STATUS_NO_CONTENT || httpResponse.statusCode == http:STATUS_ACCEPTED) {
        return {};
    }
    json jsonResponse = check httpResponse.getJsonPayload();
    return error(jsonResponse.toString());
}

isolated function getNotebookArray(http:Response response) returns Notebook[]|error {
    map<json> handledResponse = check handleResponse(response);
    return check handledResponse[VALUE].cloneWithType(NotebookArray);
}

isolated function getRecentNotebookArray(http:Response response) returns RecentNotebook[]|error {
    map<json> handledResponse = check handleResponse(response);
    return check handledResponse[VALUE].cloneWithType(RecentNotebookArray);
}

isolated function getSectionArray(http:Response response) returns Section[]|error {
    map<json> handledResponse = check handleResponse(response);
    return check handledResponse[VALUE].cloneWithType(SectionArray);
}

isolated function getSectionGroupArray(http:Response response) returns SectionGroup[]|error {
    map<json> handledResponse = check handleResponse(response);
    return check handledResponse[VALUE].cloneWithType(SectionGroupArray);
}

isolated function getPagesArray(http:Response response) returns Page[]|error {
    map<json> handledResponse = check handleResponse(response);
    return check handledResponse[VALUE].cloneWithType(PageArray);
}

isolated function createHTMLContent(string pageTitle, string pageBody) returns string {
    return "<!DOCTYPE html><html><head><title>" + pageTitle + "</title></head><body><p>" + pageBody + "</p></body></html>";
}
