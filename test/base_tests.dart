import 'dart:io';

import 'package:cloudflare/cloudflare.dart';

///
/// Make sure to set these environment variables before running tests.
/// Take into account not all envs are necessary, it depends on what kind of
/// authentication you want to use.
///
/// export CLOUDFLARE_API_URL=https://api.cloudflare.com/client/v4
/// export CLOUDFLARE_ACCOUNT_ID=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// export CLOUDFLARE_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// export CLOUDFLARE_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// export CLOUDFLARE_ACCOUNT_EMAIL=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// export CLOUDFLARE_USER_SERVICE_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxx
///
/// export CLOUDFLARE_IMAGE_FILE=/Users/user/Desktop/image-test.jpg
/// export CLOUDFLARE_IMAGE_FILE_1=/Users/user/Desktop/image-test-1.jpg
/// export CLOUDFLARE_IMAGE_FILE_2=/Users/user/Desktop/image-test-2.jpg
/// export CLOUDFLARE_IMAGE_URL=https://picsum.photos/id/237/536/354
/// export CLOUDFLARE_VIDEO_FILE=/Users/user/Desktop/video-test.mp4
/// export CLOUDFLARE_VIDEO_FILE_1=/Users/user/Desktop/video-test-1.mp4
/// export CLOUDFLARE_VIDEO_FILE_2=/Users/user/Desktop/video-test-2.mp4
/// export CLOUDFLARE_VIDEO_URL=http://clips.vorwaerts-gmbh.de/VfE_html5.mp4
///
final String? apiUrl = Platform.environment['CLOUDFLARE_API_URL'];
final String? accountId = Platform.environment['CLOUDFLARE_ACCOUNT_ID'];
final String? token = Platform.environment['CLOUDFLARE_TOKEN'];
final String? apiKey = Platform.environment['CLOUDFLARE_API_KEY'];
final String? accountEmail = Platform.environment['CLOUDFLARE_ACCOUNT_EMAIL'];
final String? userServiceKey =
    Platform.environment['CLOUDFLARE_USER_SERVICE_KEY'];

Cloudflare cloudflare = Cloudflare.basic();

Future<void> init() async {
  // print(apiUrl);
  // print(accountId);
  // print(token);

  if (accountId == null) throw Exception("accountId can't be null");

  if (cloudflare.isInitialized) return;

  cloudflare = Cloudflare(
    apiUrl: apiUrl,
    accountId: accountId!,
    token: token,
    apiKey: apiKey,
    accountEmail: accountEmail,
    userServiceKey: userServiceKey,
  );
  await cloudflare.init();
}
