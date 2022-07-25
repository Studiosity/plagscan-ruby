# Changelog

## Unreleased
- none

## [0.0.6](releases/tag/v0.0.6) - 2022-07-25
### Fixed
- [#3] Increase read timeout for Documents#create to 2 minutes

## [0.0.5](releases/tag/v0.0.5) - 2020-03-01
### Fixed
- Address CVE-2020-8130 - `rake` OS command injection vulnerability

## [0.0.4](releases/tag/v0.0.4) - 2019-12-31
### Added
- Support for some `users` APIs (list and get)

## [0.0.3](releases/tag/v0.0.3) - 2019-08-16
### Updated
- Support File params in body actions (multipart form)
- Include response body in invalid http response error message
- Symbolize names when parsing JSON response

### Removed
- Unnecessary dependency for `rest-client` gem

## [0.0.2](releases/tag/v0.0.2) - 2019-08-14
### Added
- Support for `token` API
- Support for some `documents` APIs (create, check and retrieve)

## [0.0.1](releases/tag/v0.0.1) - 2019-08-13
### Added
- Base implementation of gem along with `ping` API
