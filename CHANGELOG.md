The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Types of changes
- `Added` for new features.
- `Changed` for changes in existing functionality.
- `Deprecated` for soon-to-be removed features.
- `Removed` for now removed features.
- `Fixed` for any bug fixes.
- `Security` in case of vulnerabilities.

## 11.0.0
### Added
- Added `uploadUrl` to `TusAPI`, `tusStream` and `tusDirectStreamUpload` to resume an upload created by a previous run, even from a process that is long gone, instead of starting the file over.
- Added `onUploadCreated` callback to `TusAPI.startUpload()` to get the upload URI to persist as soon as it is known.
- Added `TusAPI.dataUploadDraft` to get the draft with the id of the video the upload produces.
- Added `progressSliceSize`, `retryDelays` and `fingerprintGenerator` to `TusAPI`, `tusStream` and `tusDirectStreamUpload`.
- Added `onError` callback to `TusAPI.startUpload()` to get errors through a callback instead of thrown exceptions.
- Added `TusAPI.close()` to dispose the http client used for tus uploads.
- Added `TusAPI.offset` to get the amount of bytes the tus server has confirmed.

### Changed
- Dependency breaking change version updated to `tusc: ^4.0.0`.
- A tus upload backed by a cache now resumes the upload previously started for the same fingerprint instead of creating a new one.
- `dataUploadDraft` is now optional in `TusAPI` and `tusDirectStreamUpload`, since an upload resumed through `uploadUrl` has already been created.
- `TusAPI.startUpload()` called while an upload is already running now adopts the callbacks given to it and joins that upload instead of starting a second one.
- `TusAPI`'s `onTimeoutCallback` is now used as the fallback for the `onTimeout` of `startUpload()`, instead of being ignored.
- `TusAPI.startUpload()`'s `onComplete` now reports `null` when nothing identifies the uploaded video, instead of a video with an empty id.

## 10.1.0
### Changed
- Changed `CopyWith` dependency.

## 10.0.0
### Added
- `R2API` — full S3-compatible Cloudflare R2 object-storage API, authenticated with AWS Signature Version 4 via `R2Credentials` (separate from the Cloudflare Bearer token used by the other APIs).

## 9.0.0
### Changed
- Dependency breaking change version updated to `tusc: ^3.0.0`.
- Updated dart sdk constraints to `sdk: '>=3.10.0 <4.0.0'`

## 8.0.0
### Changed
- Updated `CustomParseErrorLogger` with optional `Response` parameter as per new Retrofit version. 
- Updated dependencies to latest breaking change versions. 

## 7.0.0
### Added
- Added support for Web, this required several breaking changes due to the replace of `File` usage by `XFile`.
- Added `interceptors` to allow adding Dio interceptors globally.
- Added `cancelTokenCallback` to allow cancelling requests on any request globally.
- Added `cancelToken` to each individual API request.

### Changed
- Cloudflare instance initialization improved to avoid required call to `init()` function.
- Changed `HttpClient httpClient` for `HttpClientAdapter? httpClientAdapter` to allow more customization of Dio client.

## 6.0.0
### Changed
- Sdk constraint updated to: `sdk: '>=3.8.0 <4.0.0'`
- Updated dependencies to latest versions.

## 5.1.0
### Changed
- Updated dependencies to latest versions.

## 5.0.0
### Changed
- Changed hive dependency to hive_ce.

## 4.0.0
### Changed
- Updated dependencies to new breaking changes.

## 3.2.1+1
### Fixed
- `videoDeliveryUrl` fixed on `CloudflareStreamVideo`.

## 3.2.0+1
### Changed
- Some dependencies updated.
- Deprecated code refactored.
- `customAccountSubdomainUrl` field added to `CloudflareStreamVideo` to better handle serving on-demand videos and thumbnails, avoiding deprecated `videodelivery.net` and `cloudflarestream.com` domains.

## 3.1.0+16
### Added
- `httpClient` param added to `Cloudflare.basic(...)` factory constructor.

## 3.0.0+15
### Changed
- Dio and Retrofit dependencies updated to new breaking change versions.

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
