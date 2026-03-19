

## Description
This package aims to be a dart SDK for the [Cloudflare API](https://api.cloudflare.com/).
It uses [retrofit](https://pub.dev/packages/retrofit) for REST requests and [tusc](https://pub.dev/packages/tusc) for pause/resume uploads using [tus](https://tus.io) protocol.

## Available APIs

| API | Available |
| ------ | ------ |
| [Cloudflare Images](https://api.cloudflare.com/#cloudflare-images-properties) | :white_check_mark: |
| [Stream Videos](https://api.cloudflare.com/#stream-videos-properties) | :white_check_mark: |
| [Stream Live Inputs](https://api.cloudflare.com/#stream-live-inputs-properties) | :white_check_mark: |
| [R2 Object Storage](https://developers.cloudflare.com/r2/api/s3/api/) | :white_check_mark: |

- [Installation](#installation)
- [How to use](#how-to-use)
  - [Signed api access](#signed-api-access)
    - [Authorization Important Note](#authorization-important-note)
  - [Unsigned api access](#unsigned-api-access)
  - [Initialization](#once-cloudflare-instance-is-created-then-initialize-it-like-this)
  - [Some important clases](#some-important-clases)
  - [ImageAPI](#how-to-use-imageapi)
    - [Upload image](#upload-image)
    - [Upload multiple images](#upload-multiple-images)
    - [Create a direct upload](#create-a-direct-upload)
    - [Doing a direct upload](#doing-a-direct-upload)
    - [Get all images](#get-all-images)
    - [Get image by id](#get-image-by-id)
    - [Update an image](#update-an-image)
    - [Get stats](#get-stats)
    - [Delete image](#delete-image)
    - [Delete multiple images](#delete-multiple-images)
  - [StreamAPI](#how-to-use-streamapi)
    - [Stream upload](#stream-upload)
    - [Multiple stream upload](#multiple-stream-upload)
    - [Create a direct stream upload](#create-a-direct-stream-upload)
    - [Doing a direct stream upload](#doing-a-direct-stream-upload)
    - [TUS stream upload](#tus-stream-upload)
    - [Create a TUS direct stream upload](#create-a-tus-direct-stream-upload)
    - [Doing a TUS direct stream upload](#doing-a-tus-direct-stream-upload)
    - [About TUS implementation](#about-tus-implementation)
    - [Get all videos](#get-all-videos)
    - [Get video by id](#get-video-by-id)
    - [Delete video](#delete-video)
    - [Delete multiple videos](#delete-multiple-videos)
  - [LiveInputAPI](#how-to-use-liveinputapi)
    - [Create live input](#create-live-input)
    - [Get all live inputs](#get-all-live-inputs)
    - [Get live input by id](#get-live-input-by-id)
    - [Get stream videos associated to live input](#get-stream-videos-associated-to-live-input)
    - [Update a live input](#update-a-live-input)
    - [Delete live input](#delete-live-input)
    - [Delete multiple live inputs](#delete-multiple-live-inputs)
    - [Add output to live input](#add-output-to-live-input)
    - [Get outputs of a live input](#get-outputs-of-a-live-input)
    - [Remove output](#remove-output)
    - [Delete multiple live inputs](#delete-multiple-live-inputs)
  - [R2API](#how-to-use-r2api)
    - [Initialization](#r2-initialization)
    - [Credential-free initialization](#r2-credential-free-initialization)
    - [List buckets](#list-buckets)
    - [Create bucket](#create-bucket)
    - [Head bucket](#head-bucket)
    - [Delete bucket](#delete-bucket)
    - [List objects](#list-objects)
    - [Put object](#put-object)
    - [Get object](#get-object)
    - [Get object range](#get-object-range)
    - [Head object](#head-object)
    - [Copy object](#copy-object)
    - [Delete object](#delete-object)
    - [Delete multiple objects](#delete-multiple-objects)
    - [Presigned URL](#presigned-url)
    - [Direct PUT upload](#direct-put-upload)
    - [Create a direct multipart upload](#create-a-direct-multipart-upload)
    - [Doing a direct multipart upload](#doing-a-direct-multipart-upload)
    - [Multipart upload](#multipart-upload)
- [Final notes](#final-notes)


## Installation
The first thing is to add **cloudflare** as a dependency of your project, for this you can use the command:

**For purely Dart projects**
```shell
dart pub add cloudflare
```
**For Flutter projects**
```shell
flutter pub add cloudflare
```
This command will add **cloudflare** to the **pubspec.yaml** of your project.
Finally you just have to run:

`dart pub get` **or** `flutter pub get` depending on the project type and this will download the dependency to your pub-cache

## How to use
### **Signed api access:**
For server side apps where you can securely store `accountId`, `token` or any cloudflare credential, you can use the full `Cloudflare` constructor.
```dart
cloudflare = Cloudflare(
  accountId:  accountId,
  apiKey: apiKey,
  accountEmail: accountEmail,
  userServiceKey: userServiceKey,
  apiUrl: apiUrl,
  connectTimeout: connectTimeout,
  receiveTimeout: receiveTimeout,
  sendTimeout: sendTimeout,
  httpClientAdapter: httpClientAdapter,
  headers: headers,
  token: token,
  tokenCallback: tokenCallback,
  cancelTokenCallback: cancelTokenCallback,
  interceptors: interceptors,
  parseErrorLogger: parseErrorLogger,
);
```

- `accountId`: **Required** Your Cloudflare account ID. You can find it on the link when you log in to Cloudflare dashboard: `https://dash.cloudflare.com/<`account_id`>/home/domains`

- `apiKey`: **Optional** (Legacy) Global API key is the previous authorization scheme for interacting with the Cloudflare API. When possible, use API tokens instead of Global API key. Check https://developers.cloudflare.com/fundamentals/api/get-started/keys/ for more info.

- `accountEmail`: **Optional** (Legacy) To be used as `X-Auth-Email`. Email address associated with your account. When possible, use API tokens instead.

- `userServiceKey`: **Optional** (Legacy) To be used as `X-Auth-User-Service-Key`. A special Cloudflare API key good for a restricted set of endpoints. Always begins with "v1.0-", may vary in length. When possible, use API tokens instead.

- `apiUrl`: **Optional** The Cloudflare api url to request, if not specified this one will be used: https://api.cloudflare.com/client/v4

- `token`: **Optional** Cloudflare API tokens provide a new way to authenticate with the Cloudflare API. They allow for scoped and permissioned access to resources and use the RFC compliant Authorization Bearer Token Header.

- `tokenCallback`: **Optional** is a callback that returns the token to be used in the requests, it is an async way to provide the token, if you use this callback you don't have to provide the `token`.

- `connectTimeout`: **Optional** is the maximum amount of time in milliseconds that the request can take to establish a connection.

- `receiveTimeout`: **Optional** is the maximum amount of time in milliseconds that the request can take to receive data.

- `sendTimeout`: **Optional** is the maximum amount of time in milliseconds that the request can take to send data.

- `httpClientAdapter`: **Optional** is the client adapter if you need to customize how http requests are made, note you should use either `IOHttpClientAdapter` on `dart:io` native platforms or `BrowserHttpClientAdapter` on `dart:html` web platforms.

- `parseErrorLogger`: **Optional** is a logger for errors that occur during parsing of response data.

- `headers`: **Optional** allows adding global HTTP headers for all requests.

- `cancelTokenCallback`: **Optional** enables programmatically cancelling in-flight requests for this API. When cancelling a cancel token all current and future requests using the token will be cancelled. So make sure you reset the token returned by the `CancelTokenCallback` if you want to continue using the API.

- `interceptors`: **Optional** enables advanced customization like logging, retries and rate limiting.


### **Authorization Important Note**
For authorized requests to Cloudflare API you just need a `token` or `apiKey/accountEmail` or `userServiceKey` not all. Cloudflare's recommended authorization way is to use **`token`** authorization. So a valid Cloudflare full access api instance could be as simple as:

```dart
cloudflare = Cloudflare(  
  accountId: accountId,
  token: token,
);
```

If for some reason you need to use **old API keys** you can also use this valid Cloudflare instances:

```dart
cloudflare = Cloudflare(  
  accountId: accountId,
  apiKey: apiKey, 
  accountEmail: accountEmail,  
);
```
or
```dart
cloudflare = Cloudflare(  
  accountId: accountId,
  userServiceKey: userServiceKey,  
);
```

### **Unsigned api access:**
For client side apps like flutter apps where you can't securely store `accountId`, `token` or any cloudflare credential, like when you just need to do image or stream **direct upload**, it's recommended to use the `.basic()` constructor.
```dart
cloudflare = Cloudflare.basic(apiUrl: apiUrl); //apiUrl is optional
```

## Some important notes

- `CloudflareHTTPResponse`: Contains the HTTP response from a network call to a Cloudflare API endpoint.
- `CloudflareResponse`: It's the body content of a `CloudflareHTTPResponse`. [Check here](https://api.cloudflare.com/#getting-started-responses)
- `CloudflareErrorResponse`: It's the content of the error of a `CloudflareHTTPResponse`. [Also check here](https://api.cloudflare.com/#getting-started-responses)
- `CloudflareImage`: It's the representation of  Cloudflare Image data. [Check here](https://api.cloudflare.com/#cloudflare-images-properties) and [here](https://developers.cloudflare.com/images/cloudflare-images)
- `CloudflareStreamVideo`: It's the representation of Stream Video data. [Check here](https://api.cloudflare.com/#stream-videos-properties) and [here](https://developers.cloudflare.com/stream)
- `CloudflareLiveInput`: It's the representation of Stream Live Input data. [Check here](https://api.cloudflare.com/#stream-live-inputs-properties) and [here](https://developers.cloudflare.com/stream/stream-live/)
- `DataTransmit`: It's the representation of the data that will be uploaded to Cloudflare, data could be a `File`, a `String` file path, or a byte array `List<Uint8List>`. This class allows you to listen for data transmit progress, by using its `progressCallback` and also allows you to cancel a data transmit ongoing request by using the `cancelToken`.
- `CancelTokenCallback`: It's a callback that returns a `CancelToken` instance to be used in all requests, this allows you to programmatically cancel in-flight requests for the whole Cloudflare apis. When cancelling a cancel token all current and future requests using the token will be cancelled. So make sure you reset the token returned by the `CancelTokenCallback` if you want to continue using the API.
- Each API request has an optional `cancelToken` parameter that allows you to cancel individual requests.
- `R2SignedUrl`: Represents a presigned R2/S3 URL returned by `R2API.presignedUrl`. Contains the ready-to-use `url` string, the `bucket`, the object `key`, the HTTP method `type` (e.g. `"GET"` or `"PUT"`), and the `expiresAt` UTC timestamp. Use `isExpired` to check validity before sharing.
- `R2MultipartDraft`: A server-generated multipart upload session that can be handed to a credential-free client. Created by `R2API.createDirectMultipartUpload`, it bundles the `uploadId`, the target `bucket` and `key`, a list of presigned PUT part URLs (`partUrls`), a presigned POST completion URL (`completeUrl`), and the `chunkSize` used to generate the part URLs. Pass it to `R2API.basic().directMultipartUpload` on the client side.

## How to use ImageAPI

### Upload image
You can upload an image from **file**, **file path** or directly from it's binary representation as a **byte array**.
[Official documentation here](https://api.cloudflare.com/#cloudflare-images-upload-an-image-using-a-single-http-request)
```dart
//From file
CloudflareHTTPResponse<CloudflareImage?> responseFromFile = await cloudflare.imageAPI.upload(  
  contentFromFile: DataTransmit<XFile>(data: imageFile, progressCallback: (count, total) {  
    print('Upload progress: $count/$total');  
  })  
);

//From path
CloudflareHTTPResponse<CloudflareImage?> responseFromPath = await cloudflare.imageAPI.upload(
  contentFromFile: DataTransmit<XFile>(data: XFile(imagePath), progressCallback: (count, total) {  
    print('Upload progress: $count/$total');  
  })  
);

//From bytes
CloudflareHTTPResponse<CloudflareImage?> responseFromBytes = await cloudflare.imageAPI.upload(
  contentFromFile: DataTransmit<XFile>(data: XFile.fromData(imageBytes), progressCallback: (count, total) {  
    print('Upload progress: $count/$total');  
  })  
);
```

### Upload multiple images
Just like you upload an image you can also upload multiple images from **files**, **file paths** or **byte arrays**, even a mix of it, just by passing the respective list of `DataTransmit<XFile>`.
```dart
List<CloudflareHTTPResponse<CloudflareImage?>> responseFromFiles = await cloudflare.imageAPI.uploadMultiple(contentFromFiles: contentFromFiles);
```

### Create a direct upload
Creates a draft record for a future image and returns upload URL and image identifier that can be used later to verify if image itself has been uploaded or not with the draft: true property in the image response. This request is used to allow client side apps to later direct upload an image without API key or token.
[Official documentation here](https://api.cloudflare.com/#cloudflare-images-create-authenticated-direct-upload-url-v2)
```dart
final response = await cloudflare.imageAPI.createDirectUpload();  
final dataUploadDraft = response.body;
print(dataUploadDraft?.id);  
print(dataUploadDraft?.uploadURL);
```

### Doing a direct upload
For image direct upload without API key or token. This function is to be used specifically after an image `createDirectUpload` has been requested. A common place to use this is in client side apps.
[Official documentation here](https://api.cloudflare.com/#cloudflare-images-create-authenticated-direct-upload-url-v2)
```dart
final response = await cloudflare.imageAPI.directUpload(  
  dataUploadDraft: dataUploadDraft!,  
  contentFromFile: DataTransmit<XFile>(  
	data: imageFile,  
	progressCallback: (count, total) {  
		print('Image upload to direct upload URL from file: $count/$total');  
	})  
);
```

### Get all images
Up to 100 images can be listed with one request, use optional parameters to get a specific range of images.
[Official documentation here](https://api.cloudflare.com/#cloudflare-images-list-images)
```dart
CloudflareHTTPResponse<List<CloudflareImage>?> responseList = await cloudflare.imageAPI.getAll(page: 1, size: 20);
```

### Get image by id
Fetch details of a single image.

This way you get the `CloudflareImage` object.
[Official documentation here](https://api.cloudflare.com/#cloudflare-images-image-details)
```dart
CloudflareHTTPResponse<CloudflareImage> response = await cloudflare.imageAPI.get(id: imageId);
```
This way you get the binary from the originally uploaded image:
[Official documentation here](https://api.cloudflare.com/#cloudflare-images-base-image)
```dart
CloudflareHTTPResponse<List<int>?> response = await cloudflare.imageAPI.getBase(id: imageId!);
```
### Update an image
Update image access control. On access control change,  all copies of the image are purged from Cache.
[Official documentation here](https://api.cloudflare.com/#cloudflare-images-update-image)
```dart
final response = await cloudflare.imageAPI.update(  
  image: CloudflareImage(  
	id: imageId!,  
	requireSignedURLs: false,  
	meta: metadata,  
  )  
);
```
### Get stats
Fetch details of Cloudflare Images usage statistics.
[Official documentation here](https://api.cloudflare.com/#cloudflare-images-images-usage-statistics)
```dart
final CloudflareHTTPResponse<ImageStats?> response = await cloudflare.imageAPI.getStats();
```
### Delete image
Delete an image on Cloudflare Images. On success, all copies of the image are deleted and purged from Cache.
[Official documentation here](https://api.cloudflare.com/#cloudflare-images-delete-image)
```dart
final response = await cloudflare.imageAPI.delete(id: imageId);
```
### Delete multiple images
Delete a list of images on Cloudflare Images. On success, all copies of the images are deleted and purged from Cache.
```dart
final responses = await cloudflare.imageAPI.deleteMultiple(ids: idList);  
for (final response in responses) {  
  print(response.isSuccessful);  
}
```
## How to use StreamAPI
### Stream upload
A video up to 200 MegaBytes can be uploaded using a single HTTP POST (multipart/form-data) request. For larger file sizes, please upload using the TUS protocol.
You can upload a video from **url**, **file**, **file path** or directly from it’s binary representation as a **byte array**
[Official documentation here](https://api.cloudflare.com/#stream-videos-upload-a-video-using-a-single-http-request) and [here](https://api.cloudflare.com/#stream-videos-upload-a-video-from-a-url)
```dart
//From url
CloudflareHTTPResponse<CloudflareStreamVideo?> response = await cloudflare.streamAPI.stream(  
  contentFromUrl: DataTransmit<String>(  
    data: videoUrl,  
    progressCallback: (count, total) {  
      print('Stream video progress: $count/$total');  
    }
  )
);
  
//From file
CloudflareHTTPResponse<CloudflareStreamVideo?> response = await cloudflare.streamAPI.stream(  
  contentFromFile: DataTransmit<XFile>(  
    data: videoFile,  
    progressCallback: (count, total) {  
      print('Stream video progress: $count/$total');  
    }
  )
);

//From path
CloudflareHTTPResponse<CloudflareStreamVideo?> response = await cloudflare.streamAPI.stream(  
  contentFromFile: DataTransmit<XFile>(  
    data: XFile(videoPath),
    progressCallback: (count, total) {  
      print('Stream video progress: $count/$total');  
    }
  )
);

//From bytes
CloudflareHTTPResponse<CloudflareStreamVideo?> response = await cloudflare.streamAPI.stream(  
  contentFromFile: DataTransmit<XFile>(  
    data: XFile.fromData(videoBytes),
    progressCallback: (count, total) {  
      print('Stream video progress: $count/$total');  
    }
  )
);
```

### Multiple stream upload
Just like you do a stream upload you can also do multiple stream upload from **urls**, **files**, **file paths** or **byte arrays**.

```dart
//From urls
List<CloudflareHTTPResponse<CloudflareStreamVideo?>> responseFromUrls = await cloudflare.streamAPI.streamMultiple(contentFromUrls: contentFromUrls);

//From files
List<CloudflareHTTPResponse<CloudflareStreamVideo?>> responseFromFiles = await cloudflare.streamAPI.streamMultiple(contentFromFiles: contentFromFiles);
```

### Create a direct stream upload
Direct uploads allow users to upload videos without API keys. A common place to use direct uploads is on web apps, client side applications, or on mobile devices where users upload content directly to Stream. This request is used to allow client side apps to later direct stream upload a video without API key or token.

*Direct uploads occupy minutes of videos on your Stream account until they are expired. A `maxDurationSeconds` value is required to calculate the duration the video will occupy before the video is uploaded. After upload, the duration of the uploaded will be used instead. If a video longer than this value is uploaded, the video will result in an error.*
**Min value:** `1 second`
**Max value:** `21600 seconds which is 360 mins, 6 hours  `
**e.g:** `300 seconds which is 5 mins`
[Official documentation here](https://api.cloudflare.com/#stream-videos-create-a-video-and-get-authenticated-direct-upload-url)
```dart
final response = await cloudflare.imageAPI.createDirectStreamUpload(maxDurationSeconds: 60);  
final dataUploadDraft = response.body;
print(dataUploadDraft?.id);  
print(dataUploadDraft?.uploadURL);
```

### Doing a direct stream upload
For video direct stream upload without API key or token. This function is to be used specifically after a video `createDirectStreamUpload` has been requested. A common place to use this is in client side apps.

*A video up to 200 MegaBytes can be uploaded using a single HTTP POST (multipart/form-data) request.  For larger file sizes, please upload using the TUS protocol.*
[Official documentation here](https://developers.cloudflare.com/stream/uploading-videos/direct-creator-uploads/)
```dart
final response = await cloudflare.imageAPI.directStreamUpload(  
  dataUploadDraft: dataUploadDraft!,  
  contentFromFile: DataTransmit<XFile>(  
	data: imageFile,  
	progressCallback: (count, total) {  
      print('Stream video to direct upload URL from file: $count/$total');  
	})  
);
```
### TUS stream upload
For videos larger than 200 MegaBytes [tus](https://tus.io) protocol is used. **tus** protocol also allows you to pause/resume uploads. Similar to the normal stream upload described above you can also stream upload from a **file**, **file path** or **byte array** using **tus** protocol
[Official documentation here](https://developers.cloudflare.com/stream/uploading-videos/upload-video-file/#resumable-uploads-with-tus-for-large-files)
```dart
final tusAPI = await cloudflare.streamAPI.tusStream(  
  file: videoFile,
  name: 'test-video-upload',   
  cache: TusMemoryCache()    
);   
tusAPI?.startUpload(  
  onProgress: (count, total) {  
	print('tus stream video: $count/$total');  
  },  
  onComplete: (cloudflareStreamVideo) { 
  	print('tus stream video completed');   
  },  
  onTimeout: () {  
	print('tus request timeout');  
  }
);
await Future.delayed(const Duration(seconds: 2), () {  
  print('Upload paused');  
  tusAPI.pauseUpload();  
});  
await Future.delayed(const Duration(seconds: 4), () {  
  print('Upload resumed');  
  tusAPI.resumeUpload();  
});
```

### Create a TUS direct stream upload
Direct upload using tus(https://tus.io) protocol. Direct uploads allow users to upload videos without API keys. A common place to use direct uploads is on web apps, client side applications, or on mobile devices where users upload content directly to Stream.

**IMPORTANT:** when using tus protocol for direct stream upload it's not required to set a `maxDurationSeconds` because Cloudflare will reserve a loose amount o minutes for the video to be uploaded, for instance 240 minutes will be reserved from your available storage. Nevertheless it's recommended to set the `maxDurationSeconds` to avoid running out of available minutes when multiple simultaneously **tus** uploads are taking place.

**It's required to set the `size` of the file to upload.**

*Direct uploads occupy minutes of videos on your Stream account until they are expired. A `maxDurationSeconds` value is used to calculate the duration the video will occupy before the video is uploaded. After upload, the duration of the uploaded will be used instead. If a video longer than this value is uploaded, the video will result in an error.*
**Min value:** `1 second`
**Max value:** `21600 seconds which is 360 mins, 6 hours  `
**e.g:** `300 seconds which is 5 mins`
[Official documentation here](https://developers.cloudflare.com/stream/uploading-videos/direct-creator-uploads/#using-tus-recommended-for-videos-over-200mb)
```dart
final response = await cloudflare.imageAPI.createTusDirectStreamUpload(
  size: await file.length(),  
  maxDurationSeconds: videoPlayerController.value.duration.inSeconds,
  name: 'tus-video-direct-upload',
);  
final dataUploadDraft = response.body;
print(dataUploadDraft?.id);  
print(dataUploadDraft?.uploadURL);
```

### Doing a TUS direct stream upload
For larger than 200 MegaBytes video direct stream upload using [tus](https://tus.io) protocol without API key or token. This function is to be used specifically after a video `createTusDirectStreamUpload` has been requested. A common place to use this is in client side apps.
```dart
final tusAPI = await cloudflare.streamAPI.tusDirectStreamUpload(  
  dataUploadDraft: dataUploadDraft!,  
  file: videoFile,
  cache: TusPersistentCache(''),    
);   
tusAPI?.startUpload(  
  onProgress: (count, total) {  
	print('tus stream video: $count/$total');  
  },  
  onComplete: (cloudflareStreamVideo) { 
  	print('tus stream video completed');   
  },  
  onTimeout: () {  
	print('tus request timeout');  
  }
);
await Future.delayed(const Duration(seconds: 2), () {  
  print('Upload paused');  
  tusAPI.pauseUpload();  
});  
await Future.delayed(const Duration(seconds: 4), () {  
  print('Upload resumed');  
  tusAPI.resumeUpload();  
});
```

#### About TUS implementation
This package uses the [tusc](https://pub.dev/packages/tusc) package implementation, which brings two kinds of cache, `TusMemoryCache` which allows you to pause/resume uploads as long as app keeps running and `TusPersistentCache` which allows you to pause/resume uploads no matter if app closes or even device gets restarted.

### Get all videos
Up to 1000 videos can be listed with one request, use optional parameters to get a specific range of videos. Please note that Cloudflare Stream does not use pagination, instead it uses a cursor pattern to list more than 1000 videos. In order to list all videos, make multiple requests to the API using the created date-time of the last item in the previous request as the before or after parameter.
[Official documentation here](https://api.cloudflare.com/#stream-videos-list-videos)
```dart
CloudflareHTTPResponse<List<CloudflareStreamVideo>?> responseList = await cloudflare.streamAPI.getAll(
  search: 'puppy.mp4',
  before: DateTime.now(),
  limit: 20,
);
```

### Get video by id
Fetch details of a single video.
[Official documentation here](https://api.cloudflare.com/#stream-videos-video-details)
```dart
CloudflareHTTPResponse<CloudflareImage> response = await cloudflare.streamAPI.get(id: videoId);
```
### Delete video
Delete a video on Cloudflare Stream. On success, all copies of the video are deleted.
[Official documentation here](https://api.cloudflare.com/#stream-videos-delete-video)
```dart
final response = await cloudflare.streamAPI.delete(video: cloudflareStreamVideo,);
```
### Delete multiple videos
Deletes a list of videos on Cloudflare Stream. On success, all copies of the videos are deleted.
```dart
final responses = await cloudflare.streamAPI.deleteMultiple(ids: idList);  
for (final response in responses) {  
  print(response.isSuccessful);  
}
```



## How to use LiveInputAPI
### Create live input
Creates a live input that can be streamed to.
[Official documentation here](https://api.cloudflare.com/#stream-live-inputs-create-a-live-input)
```dart
final response = await cloudflare.liveInputAPI.create(  
  data: CloudflareLiveInput(  
    meta: {  
      Params.name: 'live input test name'  
    },  
    recording: LiveInputRecording(  
      mode: LiveInputRecordingMode.automatic,  
      allowedOrigins: ['example.com'],  
      timeoutSeconds: 4,  
      requireSignedURLs: true,  
    )  
  )  
);
```
### Get all live inputs
View the live inputs that have been created. Some information is not included on list requests, such as the URL to stream to. To get that information, request a single live input.
[Official documentation here](https://api.cloudflare.com/#stream-live-inputs-list-live-inputs)
```dart
final responseList = await cloudflare.liveInputAPI.getAll();
```
### Get live input by id
Fetch details about a single live input
[Official documentation here](https://api.cloudflare.com/#stream-live-inputs-live-input-details)
```dart
final response = await cloudflare.liveInputAPI.get(id: liveInputId!);
```
### Get stream videos associated to live input
Get the`CloudflareStreamVideo` list associated to a `CloudflareLiveInput`
[Official documentation here](https://developers.cloudflare.com/stream/stream-live/watch-live-stream/)
```dart
final responseList = await cloudflare.liveInputAPI.getVideos(id: liveInputId!);
```
### Update a live input
Update details about a single live input
[Official documentation here](https://api.cloudflare.com/#stream-live-inputs-update-live-input-details)
```dart
final response = await cloudflare.liveInputAPI.update(  
  liveInput: CloudflareLiveInput(  
    id: liveInputId,  
    meta: metadata,  
    recording: recording,  
  )  
);
```
### Delete live input
Prevent a live input from being streamed to. This makes the live input inaccessible to any future API calls or RTMPS transmission.
[Official documentation here](https://api.cloudflare.com/#stream-live-inputs-delete-live-input)
```dart
final response = await cloudflare.liveInputAPI.delete(id: liveInputId);
```
### Delete multiple live inputs
Deletes a list of live inputs on Cloudflare LiveInput. On success, all copies of the live inputs are deleted.
```dart
final responses = await cloudflare.liveInputAPI.deleteMultiple(ids: idList);  
for (final response in responses) {  
  print(response.isSuccessful);  
}
```
### Add output to live input
Creates a new output which will be re-streamed to by a live input
[Official documentation here](https://api.cloudflare.com/#stream-live-inputs-add-an-output-to-a-live-input)
```dart
final response = await cloudflare.liveInputAPI.addOutput(
  liveInputId: liveInputId,
  data: LiveInputOutput(
    url: 'rtmp://a.rtmp.youtube.com/live2',
    streamKey: 'uzya-f19y-g2g9-a2ee-51j2'
  )
);
```
### Get outputs of a live input
List outputs associated with a live input
[Official documentation here](https://api.cloudflare.com/#stream-live-inputs-list-outputs-associated-with-a-live-input)
```dart
final responseList = await cloudflare.liveInputAPI.getOutputs(liveInputId: liveInputId);
```
### Remove output
Removes an output from a live input
[Official documentation here](https://api.cloudflare.com/#stream-live-inputs-remove-an-output-from-a-live-input)
```dart
final response = await removeOutput(  
  liveInputId: liveInputId,  
  outputId: outputId,  
);
```
### Delete multiple live inputs
Removes a list of outputs associated to a LiveInput
```dart
final responses = await cloudflare.liveInputAPI.removeMultipleOutputs(  
  liveInputId: liveInputId,  
  outputs: outputs,  
);
```
-------------
## How to use R2API

`R2API` provides a full S3-compatible client for [Cloudflare R2 object storage](https://developers.cloudflare.com/r2/). It is **independent of the main `Cloudflare` class** — R2 uses AWS Signature Version 4 authentication with a dedicated R2 API token pair, not the Cloudflare Bearer token.

> Generate R2 API tokens at:  
> `https://dash.cloudflare.com/<accountId>/r2/api-tokens`

### R2 Initialization
```dart
final r2 = R2API(
  accountId: 'my-account-id',
  credentials: R2Credentials(
    accessKeyId: 'r2-access-key-id',
    secretAccessKey: 'r2-secret-access-key',
  ),
);
```

Optional parameters:

- `s3ApiUrl` — override the default S3-compatible endpoint (`https://<accountId>.r2.cloudflarestorage.com`). Useful for jurisdiction-specific endpoints or local mocks.
- `r2Region` — override the SigV4 signing region (default: `'auto'`). Use `'eu'` for the EU jurisdiction or `'fedramp'` for the FedRAMP-compliant endpoint.

Dispose the underlying HTTP client when done:
```dart
r2.dispose();
```

### R2 Credential-free initialization
For client-side apps (mobile, browser) that must upload to R2 **without storing any credentials**, use `R2API.basic()`.  
Only [`directPutObject`](#direct-put-upload) and [`directMultipartUpload`](#doing-a-direct-multipart-upload) are available on a `basic()` instance — every other method requires credentials and will throw a `StateError`.

```dart
final r2basic = R2API.basic();
```

The common flow is:
1. Your **backend** (authenticated instance) generates a `R2SignedUrl` or a `R2MultipartDraft`.
2. Your **client** (credential-free `basic()` instance) uses that URL / draft to upload directly to R2.

```dart
print(r2basic.isBasic); // true

// Only direct-upload methods are available:
await r2basic.directPutObject(urlData: signedUrl, content: DataTransmit<XFile>(data: file));
await r2basic.directMultipartUpload(draft: draft, content: DataTransmit<XFile>(data: largeFile));

r2basic.dispose();
```

### List buckets
```dart
final CloudflareHTTPResponse<List<R2Bucket>?> response = await r2.listBuckets();
if (response.isSuccessful) {
  for (final bucket in response.body!) {
    print('${bucket.name} — created: ${bucket.creationDate}');
  }
}
```

### Create bucket
```dart
final CloudflareHTTPResponse<R2Bucket?> response = await r2.createBucket(name: 'my-bucket');
```

### Head bucket
Returns `true` when the bucket exists, `false` on 404.
```dart
final CloudflareHTTPResponse<bool?> response = await r2.headBucket(name: 'my-bucket');
print(response.body); // true or false
```

### Delete bucket
The bucket must be empty before deletion.
```dart
final CloudflareHTTPResponse<bool?> response = await r2.deleteBucket(name: 'my-bucket');
```

### List objects
Uses ListObjectsV2. Supports prefix filtering, delimiter for virtual directories, and continuation-token pagination.
```dart
final CloudflareHTTPResponse<R2ListObjectsResult?> response = await r2.listObjects(
  bucket: 'my-bucket',
  prefix: 'images/',
  maxKeys: 100,
);

final result = response.body!;
for (final obj in result.objects) {
  print('${obj.key}  ${obj.size} bytes  etag: ${obj.etag}');
}

// Page through all results
String? token = result.nextContinuationToken;
while (token != null) {
  final next = await r2.listObjects(bucket: 'my-bucket', continuationToken: token);
  token = next.body?.nextContinuationToken;
}
```

### Put object
Upload any file as a `DataTransmit<XFile>`:
```dart
final CloudflareHTTPResponse<R2Object?> response = await r2.putObject(
  bucket: 'my-bucket',
  key: 'documents/report.pdf',
  content: DataTransmit<XFile>(data: xFile),
  contentType: 'application/pdf',
);
print(response.body?.etag);
```

### Get object
Download the full object as raw bytes:
```dart
final CloudflareHTTPResponse<Uint8List?> response = await r2.getObject(bucket: 'my-bucket', key: 'documents/report.pdf');
final bytes = response.body!;
```

### Get object range
Download a byte range (HTTP Range header):
```dart
// Fetch bytes 0–1023 (first 1 KB)
final CloudflareHTTPResponse<Uint8List?> response = await r2.getObjectRange(
  bucket: 'my-bucket',
  key: 'documents/report.pdf',
  start: 0,
  end: 1023,
);
```

### Head object
Fetch metadata without downloading the body:
```dart
final CloudflareHTTPResponse<R2Object?> response = await r2.headObject(bucket: 'my-bucket', key: 'documents/report.pdf');
print('size: ${response.body?.size}, etag: ${response.body?.etag}');
```

### Copy object
```dart
final CloudflareHTTPResponse<R2Object?> response = await r2.copyObject(
  sourceBucket: 'my-bucket',
  sourceKey: 'documents/report.pdf',
  destBucket: 'my-bucket',
  destKey: 'documents/report-copy.pdf',
);
```

### Delete object
```dart
final CloudflareHTTPResponse<bool?> response = await r2.deleteObject(bucket: 'my-bucket', key: 'documents/report.pdf');
```

### Delete multiple objects
Delete up to 1 000 keys in a single request:
```dart
final CloudflareHTTPResponse<List<String>?> response = await r2.deleteObjects(
  bucket: 'my-bucket',
  keys: ['key1.pdf', 'key2.pdf', 'key3.pdf'],
);
// response.body contains any keys that *failed* to delete (empty = all OK)
```

### Presigned URL
Generate a time-limited URL that can be shared with unauthenticated clients (max 7 days).  
`presignedUrl` returns an [`R2SignedUrl`](#some-important-notes) with the full URL string and metadata about it.

| Field | Type | Description |
|---|---|---|
| `url` | `String` | The full presigned URL to share with the client. |
| `bucket` | `String` | The R2 bucket the object lives in. |
| `key` | `String` | The object key within the bucket. |
| `type` | `String` | HTTP method the URL permits — uppercase, e.g. `"GET"` or `"PUT"`. |
| `expiresAt` | `DateTime` | UTC instant at which the URL expires (locally computed). |
| `isExpired` | `bool` | `true` once `expiresAt` is in the past. |

#### Download (presigned GET URL)
```dart
final R2SignedUrl signed = await r2.presignedUrl(
  bucket: 'my-bucket',
  key: 'documents/report.pdf',
  expiresIn: Duration(hours: 1),   // default: 1 h
  method: AWSHttpMethod.get,       // default: GET
);
// Share signed.url — no credentials required to download.
print(signed.type);      // "GET"
print(signed.expiresAt); // 2026-03-16T13:00:00.000Z
print(signed.isExpired); // false
```

#### Client-side upload (presigned PUT URL)
The common pattern for browser or mobile apps that must upload directly to R2 without exposing credentials:
```dart
// Backend: generate a presigned PUT URL valid for 15 minutes.
final R2SignedUrl signed = await r2.presignedUrl(
  bucket: 'my-bucket',
  key: 'uploads/document.pdf',
  method: AWSHttpMethod.put,
  expiresIn: Duration(minutes: 15),
);
print(signed.type); // "PUT"

// Client: upload directly to R2 — no R2 credentials required.
final response = await http.put(
  Uri.parse(signed.url),
  headers: {'content-type': 'application/pdf'},
  body: pdfBytes,
);
// HTTP 200 or 204 → upload succeeded.
```

### Direct PUT upload
Upload a file **without any credentials** to a presigned PUT URL previously generated by your backend.  
Uses Dio internally for real-time progress callbacks and cancellation support.  
Mirrors `directStreamUpload` from `StreamAPI`.

**Use this for files that fit in a single request (up to ~5 GB for R2).**

```dart
// ── Backend (authenticated) ──────────────────────────────────────────────
final R2SignedUrl signed = await r2.presignedUrl(
  bucket: 'my-bucket',
  key: 'uploads/document.pdf',
  method: AWSHttpMethod.put,
  expiresIn: Duration(minutes: 15),
);
// Send `signed` to your client (e.g. as JSON via your REST API).

// ── Client (no credentials) ──────────────────────────────────────────────
final r2basic = R2API.basic();

final response = await r2basic.directPutObject(
  urlData: signed,
  content: DataTransmit<XFile>(
    data: XFile('/path/to/document.pdf'),
    progressCallback: (count, total) {
      print('Upload progress: $count / $total bytes');
    },
  ),
  cancelToken: myCancelToken, // optional — also available on DataTransmit
);

if (response.isSuccessful) {
  print('Uploaded! etag: ${response.body?.etag}');
} else {
  print('Error: ${response.error}');
}

r2basic.dispose();
```

### Create a direct multipart upload
**Server-side / authenticated step.**  
Creates a multipart upload session and pre-generates all the presigned URLs the client needs — one PUT URL per chunk and one POST URL to complete the upload.  
Mirrors `createTusDirectStreamUpload` from `StreamAPI`.

**Use this for large files (> 5 GB or when progress and resumability matter).**

```dart
final CloudflareHTTPResponse<R2MultipartDraft?> res =
    await r2.createDirectMultipartUpload(
  bucket: 'my-bucket',
  key: 'uploads/video.mp4',
  fileSize: await videoFile.length(),  // required — determines part count
  chunkSize: 10 * 1024 * 1024,         // optional, default 5 MB (S3 minimum)
  contentType: 'video/mp4',
  expiresIn: Duration(hours: 1),       // optional, default 1 h (max 7 days)
);

final R2MultipartDraft draft = res.body!;
print('uploadId: ${draft.uploadId}');
print('parts:    ${draft.partUrls.length}');
// Send `draft` to your client (e.g. as JSON via your REST API —
// R2MultipartDraft is fully JSON-serialisable).
```

`R2MultipartDraft` fields:

| Field | Type | Description |
|---|---|---|
| `uploadId` | `String` | S3 multipart upload session ID. |
| `bucket` | `String` | Target R2 bucket. |
| `key` | `String` | Target object key. |
| `partUrls` | `List<R2SignedUrl>` | Presigned PUT URLs — one per chunk, in order. Index 0 → `partNumber=1`. |
| `completeUrl` | `R2SignedUrl` | Presigned POST URL to finalise the upload. |
| `chunkSize` | `int` | Byte size of each chunk used when the part URLs were generated. |

### Doing a direct multipart upload
**Client-side / credential-free step.**  
Uses the `R2MultipartDraft` from the backend to upload the file in chunks, report aggregated progress, and complete the upload — no credentials required.  
Mirrors `tusDirectStreamUpload` from `StreamAPI`.

```dart
// ── Client (no credentials) ──────────────────────────────────────────────
final r2basic = R2API.basic();

final response = await r2basic.directMultipartUpload(
  draft: draft,  // R2MultipartDraft received from your backend
  content: DataTransmit<XFile>(
    data: XFile('/path/to/video.mp4'),
    progressCallback: (count, total) {
      // Aggregated across all parts — count / total give overall byte progress.
      print('Upload progress: $count / $total bytes');
    },
  ),
  cancelToken: myCancelToken, // optional — also available on DataTransmit
);

if (response.isSuccessful) {
  print('Uploaded! etag: ${response.body?.etag}');
} else {
  print('Error: ${response.error}');
}

r2basic.dispose();
```

> **Note on cancellation:** cancelling stops the current in-flight part. Already-uploaded parts remain in R2 until the session is explicitly aborted server-side via `r2.abortMultipartUpload(draft.bucket, draft.key, draft.uploadId)` or until the presigned URLs expire.

### Multipart upload
Recommended for files larger than ~5 GB. Each part (except the last) must be ≥ 5 MB.
```dart
// 1. Initiate
final initRes = await r2.createMultipartUpload(
  bucket: 'my-bucket',
  key: 'videos/big.mp4',
  contentType: 'video/mp4',
);
final uploadId = initRes.body!;

// 2. Upload parts (collect ETags)
final Map<int, String> parts = {};
int partNumber = 1;
for (final chunk in chunks) {           // chunks: List<Uint8List>
  final partRes = await r2.uploadPart(
    bucket: 'my-bucket',
    key: 'videos/big.mp4',
    uploadId: uploadId,
    partNumber: partNumber,
    data: chunk,
  );
  parts[partNumber] = partRes.body!;    // ETag returned by R2
  partNumber++;
}

// 3. Complete
final completeRes = await r2.completeMultipartUpload(
  bucket: 'my-bucket',
  key: 'videos/big.mp4',
  uploadId: uploadId,
  parts: parts,
);
print(completeRes.body?.etag);

// Abort if something goes wrong instead of completing
await r2.abortMultipartUpload(
  bucket: 'my-bucket',
  key: 'videos/big.mp4',
  uploadId: uploadId,
);
```

-------------
### Final notes:
- Every class, property and function is documented and references Cloudfare's official documentation.
- Check the example project to see how to use this package from a flutter app.
- Check the unit and integration tests to see how to use each api in details.