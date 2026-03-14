# AGENTS.md — Cloudflare Dart SDK

## Project Overview
A pure-Dart/Flutter package providing a typed SDK for the Cloudflare REST APIs (Images, Stream Videos, Stream Live Inputs). It is published to pub.dev and is **not** a Flutter app — the `example/` directory contains a Flutter app demonstrating usage.

## Key Commands

| Task | Command |
|---|---|
| Code generation (after model/annotation changes) | `make generate-code` |
| Format code | `make format` |

## Architecture

### Layered Structure
```
Cloudflare (entry point, lib/cloudflare.dart)
  └─ RestAPI  (lib/src/base_api/rest_api.dart)           — Dio client, auth interceptors
  └─ RestAPIService<I, DataType, ErrorType>               — abstract base for all API classes
       ├─ ImageAPI    → ImageService    (retrofit-generated)
       ├─ StreamAPI   → StreamService   (retrofit-generated)
       └─ LiveInputAPI → LiveInputService (retrofit-generated)
```

- **`lib/src/service/*.dart`** — Retrofit `@RestApi()` abstract classes; **all HTTP wiring lives here**. Concrete implementations are code-generated (`*.g.dart`).
- **`lib/src/apiservice/*.dart`** — High-level API classes that wrap the service layer, handle multipart uploads, TUS protocol, `DataTransmit` progress callbacks, and `XFile` → bytes conversion.
- **`lib/src/entity/*.dart`** — JSON-serialisable domain objects (`@JsonSerializable` + `@CopyWith`).
- **`lib/src/model/*.dart`** — Non-domain models: `CloudflareHTTPResponse<T>`, `DataTransmit<T>`, `Pagination`, error types.
- **`TusAPI`** (`lib/src/apiservice/tus_api.dart`) — Wraps `tusc` package for chunked, resumable video uploads. Instantiated by `StreamAPI` as a separate object, not as part of the retrofit service.

### Two Constructors on `Cloudflare`
- `Cloudflare(accountId: ..., token: ...)` — full, server-side, authorized access.
- `Cloudflare.basic()` — no credentials; only `directUpload` endpoints work (client-side uploads via a pre-signed `uploadURL`).

### Auth Strategy
Token auth is preferred; legacy `apiKey`+`accountEmail` and `userServiceKey` are `@Deprecated`. The Dio interceptor in `RestAPI._initDio()` injects auth headers from `tokenCallback` or static headers map.

## Code Generation
All `*.g.dart` files are **generated** — never edit them manually.

Generators used (see `build.yaml`):
| Generator | Targets |
|---|---|
| `json_serializable` | `**/entity/*.dart`, `**/model/*.dart` |
| `copy_with_extension_gen` | same |
| `retrofit_generator` | `**/service/*.dart` |

**Run after any change to entity/model/service files:**
```sh
make generate-code
# or
dart run build_runner build --delete-conflicting-outputs
```

## Developer Workflows

| Task | Command |
|---|---|
| Generate code | `make generate-code` |
| Format | `make format` |
| Auto-fix | `make fix` |
| Dry-run publish | `make check-publish` |
| Publish | `make publish` |
| Run tests | `dart test test/<name>_test.dart` |

### Running Tests
Tests hit the **real Cloudflare API** and require environment variables:
```sh
export CLOUDFLARE_ACCOUNT_ID=xxx
export CLOUDFLARE_TOKEN=xxx
export CLOUDFLARE_IMAGE_FILE=/path/to/image.jpg
export CLOUDFLARE_VIDEO_FILE=/path/to/video.mp4
# See test/base_tests.dart for full list
dart test test/image_api_test.dart
```
`test/base_tests.dart` provides shared `init()`, env-var parsing, and `XFileUtils` helpers used by all test files.

## Key Patterns

### Adding a New Entity
1. Create `lib/src/entity/my_entity.dart` extending `Jsonable<MyEntity>` with `@JsonSerializable()` + `@CopyWith()`.
2. Add `part 'my_entity.g.dart';` and implement `toJson()`/`fromJsonMap()`.
3. Run `make generate-code`.
4. Export from `lib/cloudflare.dart`.

### Adding a New Service Endpoint
1. Add `@GET`/`@POST`/etc. method to the relevant `lib/src/service/*_service.dart` abstract class.
2. Run `make generate-code`.
3. Add the public-facing method in the corresponding `lib/src/apiservice/*_api.dart`.

### `DataTransmit<T>` Pattern
Wrap file/url data in `DataTransmit` to attach `progressCallback` and `cancelToken`:
```dart
cloudflare.imageAPI.upload(
  contentFromFile: DataTransmit<XFile>(
    data: xfile,
    progressCallback: (count, total) { ... },
    cancelToken: myCancelToken,
  ),
);
```

### Response Handling
All API methods return `CloudflareHTTPResponse<T?>`. Check `.isSuccessful` and `.error` (a `CloudflareErrorResponse`) before accessing `.body`.

## Important Notes
- `dart:io`-based `File` is **intentionally avoided** in service layer for web compatibility; `XFile` (from `cross_file`) is used instead.
- `json_serializable` is configured globally with `include_if_null: false` (see `build.yaml`).
- The `gen/` directory at project root is reserved for generation output but currently empty.
- Hive TUS cache files (`tus/`) persist upload state for resumable uploads.

