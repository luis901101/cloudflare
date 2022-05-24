

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
  - [Authorized api access](#authorized-api-access)
    - [Authorization Important Note](#authorization-important-note)
  - [Not authorization required api access](#not-authorization-required-api-access)
  - [Initialization](#once-cloudflare-instance-is-created-then-initialize-it-like-this)
  - [Some important clases](#some-important-clases)
  - [ImageAPI](#how-to-use-imageapi)
    - [Upload image](#upload-image)
    - [Upload multiple images](#upload-multiple-images)
    - [Create a direct upload](#create-a-direct-upload)
    - [Doing a direct upload](#doing-a-direct-upload)
    - [Get all images](#get-all-images)
    - [Get image by id](#get-image-by-id)
    - [Update an image](#update_an-image)
    - [Get stats](#get-stats)
    - [Delete image](#delete-image)
    - [Delete multiple images](#delete-multiple-images)
- [Recommendations](#recommendations)


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
### **Authorized api access:**
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

### **Not authorization required api access:**
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
```dart
final response = await cloudflare.imageAPI.createDirectUpload();  
final dataUploadDraft = response.body;
print(dataUploadDraft?.id);  
print(dataUploadDraft?.uploadURL);
```

### Doing a direct upload
For image direct upload without API key or token. This function is to be used specifically after an image `createDirectUpload` has been requested. A common place to use this is in client side apps.
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
```dart
CloudflareHTTPResponse<List<CloudflareImage>?> responseList = await cloudflare.imageAPI.getAll(page: 1, size: 20);
```

### Get image by id
This way you get the `CloudflareImage` object.
```dart
CloudflareHTTPResponse<CloudflareImage> response = await cloudflare.imageAPI.get(id: imageId);
```
This way you get the binary from the originally uploaded image:
```dart
CloudflareHTTPResponse<List<int>?> response = await cloudflare.imageAPI.getBase(id: imageId!);
```
### Update an image
Update image access control. On access control change,  all copies of the image are purged from Cache.
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
Fetch details of Cloudflare Images usage statistics
```dart
final CloudflareHTTPResponse<ImageStats?> response = await cloudflare.imageAPI.getStats();
```
### Delete image
Delete an image on Cloudflare Images. On success, all copies of the image are deleted and purged from Cache.
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

-------------
### Recommendations:
- Check the example project to see how to use this package from a flutter app.
- Check the unit tests to see how to use each api in details.