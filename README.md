
## Description
This package aims to be a flutter SDK for the Image and Stream [Cloudflare API](https://api.cloudflare.com/).

## Available APIs

| API | Available |
| ------ | ------ |
| Image | :white_check_mark: |
| Stream | :ballot_box_with_check: |

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

`dart pub get` **or** `flutter pub get` depending on the project type to download the dependency to your pub-cache

## How to use
### **Very simple, just build an instance of Cloudflare SDK like this:**
```dart
cloudflare = Cloudflare(  
  apiUrl: apiUrl,
  accountId: accountId,
  token: token,
  apiKey: apiKey, 
  accountEmail: accountEmail,  
  userServiceKey: userServiceKey,  
);
```
`apiUrl`: This is the base url for Cloudflare APIs, at the time of writing this, the url us: https://api.cloudflare.com/client/v4

`accountId`: The accountId that identifies your Cloudflare account, you can find this id on your Developer Resources at your [Cloudflare Dash](https://dash.cloudflare.com/) or simply copying from the url when you select the account at Cloudflare Dash; something like https://dash.cloudflare.com/xxxxxxxxxxxxxxx/images/images.

`token`: The API Token provide a new way to authenticate with the Cloudflare API. It allows for scoped and permissioned access to resources. This token can be generated from [User Profile 'API Tokens' page](https://dash.cloudflare.com/profile/api-tokens)

`apiKey`: API key generated on the "My Account" page

`accountEmail`: Email address associated with your account

`userServiceKey`: A special Cloudflare API key good for a restricted set of endpoints. Always begins with "v1.0-", may vary in length.

### **Authorization Important Note**
For authorized requests to Cloudflare API you just need a `token` or `apiKey/accountEmail` or `userServiceKey` not all. Cloudflare's recommended authorization way is to use **`token`** authorization. So a valid Cloudflare instance could be:

```dart
cloudflare = Cloudflare(  
  apiUrl: apiUrl,
  accountId: accountId,
  token: token,
);
```

If for some reason you need to use **old API keys** you can also use this valid Cloudflare instances:

```dart
cloudflare = Cloudflare(  
  apiUrl: apiUrl,
  accountId: accountId,
  apiKey: apiKey, 
  accountEmail: accountEmail,  
);
```
or
```dart
cloudflare = Cloudflare(  
  apiUrl: apiUrl,
  accountId: accountId,
  userServiceKey: userServiceKey,  
);
```

## Once Cloudflare instance is created then initialize it like this:
```dart
await cloudflare.init();
```
Done, you can now access Cloudflare API.

## Some important clases

`CloudflareHTTPResponse`: Contains the HTTP response from a network call to a Cloudflare API endpoint.
`CloudflareResponse`: It's the body content of a `CloudflareHTTPResponse`. [Check here](https://api.cloudflare.com/#getting-started-responses)
`CloudflareErrorResponse`: It's the content of the error of a `CloudflareHTTPResponse`. [Also check here](https://api.cloudflare.com/#getting-started-responses)
`CloudflareImage`: It's the representation of  Cloudflare Image data. [Check here](https://api.cloudflare.com/#cloudflare-images-properties)

## How to use ImageAPI

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
  contentFromBytes: DataTransmit<List<int>>(data: imageBytes, progressCallback: (count, total) {  
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
-------------
### **For more examples about how to use this package check the example project and unit tests**