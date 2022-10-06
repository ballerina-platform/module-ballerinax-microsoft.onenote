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
import ballerinax/'client.config;

# Client configuration details.
@display {label: "Connection Config"}
public type ConnectionConfig record {|
    *config:ConnectionConfig;
    # Configurations related to client authentication
    http:BearerTokenConfig|config:OAuth2RefreshTokenGrantConfig auth;
|};

# Represents a Notebook.
#
# + createdBy - Identity of the user, device, and application which created the item
# + createdDateTime - The date and time when the notebook was created
# + id - The unique identifier of the notebook
# + isDefault - Indicates whether this is the user's default notebook
# + isShared - Indicates whether the notebook is shared. If true, the contents of the notebook can be seen by people 
#  other than the owner. 
# + lastModifiedBy - Identity of the user, device, and application which created the item
# + lastModifiedDateTime - The date and time when the notebook was last modified
# + links - Links for opening the notebook. The oneNoteClientURL link opens the notebook in the OneNote native client 
# if it's installed. The oneNoteWebURL link opens the notebook in OneNote on the web.
# + displayName - The name of the notebook.
# + sectionGroupsUrl - The URL for the sectionGroups navigation property, which returns all the section groups in the notebook
# + sectionsUrl - The URL for the sections navigation property, which returns all the sections in the notebook
# + self - The endpoint where you can get details about the notebook
# + userRole - Possible values are: Owner, Contributor, Reader, None. Owner represents owner-level access to the notebook.
#  Contributor represents read/write access to the notebook. Reader represents read-only access to the notebook.
@display {label: "Notebook"}
public type Notebook record {
    string id;
    string displayName;
    json createdBy;
    string createdDateTime;
    boolean isDefault;
    boolean isShared;
    json lastModifiedBy;
    string lastModifiedDateTime;
    json links;
    string sectionGroupsUrl;
    string sectionsUrl;
    string self;
    string userRole;
};

# Represents a RecentNotebook.
#
# + displayName - The name of the notebook
# + lastAccessedTime - The date and time when the notebook was last accessed
# + links - Links for opening the notebook
# + sourceService - Source service
@display {label: "Recent Notebook"}
public type RecentNotebook record {
    string displayName;
    string lastAccessedTime;
    json links;
    string sourceService;
};

# Represents a Section.
#
# + createdBy - Identity of the user, device, and application which created the item
# + createdDateTime - The date and time when the section was created
# + id - The unique identifier of the section 
# + isDefault - Indicates whether this is the user's default section 
# + lastModifiedBy - Identity of the user, device, and application which created the item  
# + lastModifiedDateTime - The date and time when the section was last modified
# + displayName - The name of the section 
# + pagesUrl - The pages endpoint where you can get details for all the pages in the section  
# + self - The endpoint where you can get details about the section
@display {label: "Section"}
public type Section record {
    string id;
    string displayName;
    json createdBy;
    string createdDateTime;
    boolean isDefault;
    json lastModifiedBy;
    string lastModifiedDateTime;
    string pagesUrl;
    string self;
};

# Represents a SectionGroup.
#
# + createdBy - Identity of the user, device, and application which created the item  
# + createdDateTime - The date and time when the section group was created
# + id - The unique identifier of the section group 
# + lastModifiedBy - Identity of the user, device, and application which created the item 
# + lastModifiedDateTime - The date and time when the section group was last modified
# + sectionGroupsUrl - The URL for the sectionGroups navigation property, which returns all the section groups in the section group
# + sectionsUrl - The URL for the sections navigation property, which returns all the sections in the section group
# + self - The endpoint where you can get details about the section group
# + displayName - The name of the section group 
@display {label: "Section Group"}
public type SectionGroup record {
    string id;
    string displayName;
    json createdBy;
    string createdDateTime;
    json lastModifiedBy;
    string lastModifiedDateTime;
    string sectionGroupsUrl;
    string sectionsUrl;
    string self;
};

# Represents a Page.
#
# + createdDateTime - The date and time when the page was created  
# + id - The unique identifier of the page  
# + lastModifiedDateTime - The date and time when the page was last modified  
# + self - 	The endpoint where you can get details about the page   
# + title - The title of the page   
# + content - The page's HTML content   
# + contentUrl - The URL for the page's HTML content   
# + createdByAppId - The unique identifier of the application that created the page. Read-only
@display {label: "Page"}
public type Page record {
    string id;
    string title;
    string createdDateTime;
    string lastModifiedDateTime;
    string self;
    byte[] content?;
    string contentUrl;
    string createdByAppId?;
};

type NotebookArray Notebook[];
type SectionArray Section[];
type SectionGroupArray SectionGroup[];
type PageArray Page[];
type RecentNotebookArray RecentNotebook[];
