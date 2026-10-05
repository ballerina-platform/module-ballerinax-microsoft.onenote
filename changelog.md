# Change Log

This file contains all the notable changes done to the Ballerina Microsoft OneNote connector through the releases.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- The connector now covers the Microsoft Graph v1.0 OneNote surface: 318 operations over notebooks, section groups,
  sections, pages, page content, resources and long-running copy operations, for both the signed-in user (`/me`) and a
  user by ID (`/users/{userId}`).
- Operations to copy notebooks, sections and pages, to patch page content, to preview a page, to find a notebook from
  its web URL and to list recently accessed notebooks.
- OAuth 2.0 authorization code flow support through `OAuth2RefreshTokenGrantConfig` with the `Notes.*` permissions.

### Changed

- All operations are generated as remote methods, named after the action and the resource they act on, for example
  `listNotebooks`, `createNotebookSection` and `getUserNotebook`.
- The `@odata.type` property of the Microsoft Graph records is optional.
