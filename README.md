

## Description
This package aims to be a flutter SDK for the Image and Stream [Cloudflare API](https://api.cloudflare.com/).

## Available APIs

| API | Available |
| ------ | ------ |
| Cloudflare Images | :white_check_mark: |
| Stream Videos | :white_check_mark: |
| Stream Live Inputs | :white_check_mark: |

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
  apiUrl: apiUrl,
  accountId: accountId,
  token: token,
  apiKey: apiKey, 
  accountEmail: accountEmail,  
  userServiceKey: userServiceKey,  
  timeout: timeout,
  httpClient: httpClient,
);
```
`apiUrl`: **Optional**. This is the base url for Cloudflare APIs, at the time of writing this, the url is: https://api.cloudflare.com/client/v4, which is used by default.

`accountId`: **Required**. The accountId that identifies your Cloudflare account, you can find this id on your Developer Resources at your [Cloudflare Dash](https://dash.cloudflare.com/) or simply copying from the url when you select the account at Cloudflare Dash; something like https://dash.cloudflare.com/xxxxxxxxxxxxxxx/images/images.

`token`: **Optional**. The API Token provide a new way to authenticate with the Cloudflare API. It allows for scoped and permissioned access to resources. This token can be generated from [User Profile 'API Tokens' page](https://dash.cloudflare.com/profile/api-tokens)

`apiKey`: **Optional**. API key generated on the "My Account" page

`accountEmail`: **Optional**. Email address associated with your account

`userServiceKey`: **Optional**. A special Cloudflare API key good for a restricted set of endpoints. Always begins with "v1.0-", may vary in length.

`timeout`: **Optional**. The duration to wait until an api request should timeout.

`httpClient`: **Optional**. Set this if you need control over http requests like validating certificates and so. Not supported in Web.

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


## Once Cloudflare instance is created then initialize it like this:
```dart
await cloudflare.init();
```
Done, you can now access Cloudflare API.

## Some important clases

- `CloudflareHTTPResponse`: Contains the HTTP response from a network call to a Cloudflare API endpoint.
- `CloudflareResponse`: It's the body content of a `CloudflareHTTPResponse`. [Check here](https://api.cloudflare.com/#getting-started-responses)
- `CloudflareErrorResponse`: It's the content of the error of a `CloudflareHTTPResponse`. [Also check here](https://api.cloudflare.com/#getting-started-responses)
- `CloudflareImage`: It's the representation of  Cloudflare Image data. [Check here](https://api.cloudflare.com/#cloudflare-images-properties) and [here](https://developers.cloudflare.com/images/cloudflare-images)
- `CloudflareStreamVideo`: It's the representation of Stream Video data. [Check here](https://api.cloudflare.com/#stream-videos-properties) and [here](https://developers.cloudflare.com/stream)
- `CloudflareLiveInput`: It's the representation of Stream Live Input data. [Check here](https://api.cloudflare.com/#stream-live-inputs-properties) and [here](https://developers.cloudflare.com/stream/stream-live/)

## How to use ImageAPI

### Upload image
You can upload an image from **file**, **file path** or directly from it's binary representation as a **byte array**.
[Official documentation here](https://api.cloudflare.com/#cloudflare-images-upload-an-image-using-a-single-http-request)
```dart
//From file
CloudflareHTTPResponse<CloudflareImage?> responseFromFile = await cloudflare.imageAPI.upload(  
  contentFromFile: DataTransmit<File>(data: imageFile, progressCallback: (count, total) {  
    print('Upload progress: $count/$total');  
  })  
);

//From path
CloudflareHTTPResponse<CloudflareImage?> responseFromPath = await cloudflare.imageAPI.upload(  
  contentFromPath: DataTransmit<String>(data: imagePath, progressCallback: (count, total) {  
    print('Upload progress: $count/$total');  
  })  
);

//From bytes
CloudflareHTTPResponse<CloudflareImage?> responseFromBytes = await cloudflare.imageAPI.upload(  
  contentFromBytes: DataTransmit<Uint8List>(data: imageBytes, progressCallback: (count, total) {  
    print('Upload progress: $count/$total');  
  })  
);
```

### Upload multiple images
Just like you upload an image you can also upload multiple images from **files**, **file paths** or **byte arrays**.
```dart
//From files
List<CloudflareHTTPResponse<CloudflareImage?>> responseFromFiles = await cloudflare.imageAPI.uploadMultiple(contentFromFiles: contentFromFiles);

//From paths
List<CloudflareHTTPResponse<CloudflareImage?>> responseFromPaths = await cloudflare.imageAPI.uploadMultiple(contentFromPaths: contentFromPaths);

//From bytes
List<CloudflareHTTPResponse<CloudflareImage?>> responseFromBytes = await cloudflare.imageAPI.uploadMultiple(contentFromBytes: contentFromBytes);
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
  contentFromFile: DataTransmit<File>(  
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
A video up to 200 MegaBytes can be uploaded using a single HTTP POST (multipart/form-data) request.  For larger file sizes, please upload using the TUS protocol.
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
  contentFromFile: DataTransmit<File>(  
    data: videoFile,  
    progressCallback: (count, total) {  
      print('Stream video progress: $count/$total');  
    }
  )
);

//From path
CloudflareHTTPResponse<CloudflareStreamVideo?> response = await cloudflare.streamAPI.stream(  
  contentFromFile: DataTransmit<String>(  
    data: videoFile.path,  
    progressCallback: (count, total) {  
      print('Stream video progress: $count/$total');  
    }
  )
);

//From bytes
CloudflareHTTPResponse<CloudflareStreamVideo?> response = await cloudflare.streamAPI.stream(  
  contentFromFile: DataTransmit<Uint8List>(  
    data: videoFile.readAsBytesSync(),  
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

//From paths
List<CloudflareHTTPResponse<CloudflareStreamVideo?>> responseFromPaths = await cloudflare.streamAPI.streamMultiple(contentFromPaths: contentFromPaths);

//From bytes
List<CloudflareHTTPResponse<CloudflareImageCloudflareStreamVideo?>> responseFromBytes = await cloudflare.streamAPI.streamMultiple(contentFromBytes: contentFromBytes);
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
  contentFromFile: DataTransmit<File>(  
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
  size: File(dataVideo!.dataTransmit.data).lengthSync(),  
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
### Final notes:
- Every class, property and function is documented and references Cloudfare's official documentation.
- Check the example project to see how to use this package from a flutter app.
- Check the unit tests to see how to use each api in details.