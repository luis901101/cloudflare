
import 'dart:io';

import 'package:cloudflare/cloudflare.dart';

/// Make sure to set all of this environment variables before running tests
///
/// export CLOUDFLARE_IMAGE_FILE=/Users/krrigan/Desktop/flckn-demo-test.jpg
/// export CLOUDFLARE_API_URL=https://api.cloudflare.com/client/v4
/// export CLOUDFLARE_ACCOUNT_ID=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// export CLOUDFLARE_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// export CLOUDFLARE_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// export CLOUDFLARE_ACCOUNT_EMAIL=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// export CLOUDFLARE_USER_SERVICE_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxx
///
final String? apiUrl = Platform.environment['CLOUDFLARE_API_URL'];
final String? accountId = Platform.environment['CLOUDFLARE_ACCOUNT_ID'];
final String? token = Platform.environment['CLOUDFLARE_TOKEN'];
final String? apiKey = Platform.environment['CLOUDFLARE_API_KEY'];
final String? accountEmail = Platform.environment['CLOUDFLARE_ACCOUNT_EMAIL'];
final String? userServiceKey = Platform.environment['CLOUDFLARE_USER_SERVICE_KEY'];

Cloudflare cloudflare = Cloudflare(accountId: '', token: '');

Future<void> init() async {

  // print(apiUrl);
  // print(accountId);
  // print(token);

  if(accountId == null) throw Exception("accountId can't be null");

  if(cloudflare.isInitialized) return;

  cloudflare = Cloudflare(
    apiUrl: apiUrl,
    accountId: accountId!,
    token: token,
    // apiKey: apiKey,
    // accountEmail: accountEmail,
    // userServiceKey: userServiceKey,
  );
  await cloudflare.init();
}
