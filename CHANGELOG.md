The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Types of changes
- `Added` for new features.
- `Changed` for changes in existing functionality.
- `Deprecated` for soon-to-be removed features.
- `Removed` for now removed features.
- `Fixed` for any bug fixes.
- `Security` in case of vulnerabilities.

## 2.1.0+14
### Added
- Custom `fileName` can be specified for image upload from file, path and bytes, whether signed upload or direct upload.
- Custom `fileName` can be specified for stream upload from file, path and bytes, whether signed upload or direct upload.

## 2.0.0+13
### Changed
- Dependency breaking change version updated to `copy_with_extension: ^5.0.0`.

## 1.3.1+12
### Fixed
- Fixed a bug with status query param in getting all stream videos request. 

## 1.3.0+11
### Added
- `connectTimeout`, `receiveTimeout` and `sendTimeout` added to support different Dio timeouts.

## 1.2.0+9
### Added
- Support for specific account subdomain streaming url. 
- `CloudflareStreamVideo.fromUrl(...)` accepts urls like `https://customer-{CODE}.cloudflarestream.com` 

## 1.1.0+8
### Added
- `DataTransmit` adds a `CancelToken` property to allow to cancel requests on any request that uses a `DataTransmit` instance, like image upload or video stream upload.

## 1.0.1+7
### Fixed
- Wrong assert validation removed from `tusDirectStreamUpload(...)` function that prevented from doing direct stream upload using tus protocol.

## 1.0.0+6
### Changed
- `dataFromImageDeliveryUrl` function from `CloudflareImage` made public
- `dataFromVideoDeliveryUrl` function from `CloudflareStreamVideo` made public

## 1.0.0+5
### Fixed
- Minor bugs fixed in flutter example project

## 1.0.0+4
### Added
- StreamAPI implemented
- LiveInputAPI implemented

### Changed
- ImageAPI updated

## 0.0.1+2
### Fixed
- Readme description.

## 0.0.1+1
### Added
- Initial version.
