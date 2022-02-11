import 'dart:async';
import 'dart:io';
import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare_example/src/app.dart';
import 'package:cloudflare_example/src/utils/alert_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloudflare_example/src/utils/image_utils.dart';
import 'package:image_picker/image_picker.dart';

/// Make sure to put environment variables in your
/// flutter run command or in your Additional run args in your selected
/// configuration.
/// Take into account not all envs are necessary, it depends on what kind of
/// authentication you want to use.
///
/// For example:
///
/// flutter run
/// --dart-define=CLOUDFLARE_API_URL=https://api.cloudflare.com/client/v4
/// --dart-define=CLOUDFLARE_ACCOUNT_ID=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// --dart-define=CLOUDFLARE_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// --dart-define=CLOUDFLARE_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// --dart-define=CLOUDFLARE_ACCOUNT_EMAIL=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// --dart-define=CLOUDFLARE_USER_SERVICE_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxx
///
const String apiUrl = String.fromEnvironment('CLOUDFLARE_API_URL', defaultValue: 'https://api.cloudflare.com/client/v4');
const String accountId = String.fromEnvironment('CLOUDFLARE_ACCOUNT_ID', defaultValue: '');
const String token = String.fromEnvironment('CLOUDFLARE_TOKEN', defaultValue: '');
const String apiKey = String.fromEnvironment('CLOUDFLARE_API_KEY', defaultValue: '');
const String accountEmail = String.fromEnvironment('CLOUDFLARE_ACCOUNT_EMAIL', defaultValue: '');
const String userServiceKey = String.fromEnvironment('CLOUDFLARE_USER_SERVICE_KEY', defaultValue: '');

late Cloudflare cloudflare;

void main() async {
  try {
    cloudflare = Cloudflare(
      apiUrl: apiUrl,
      accountId: accountId,
      token: token,
      apiKey: apiKey,
      accountEmail: accountEmail,
      userServiceKey: userServiceKey,
    );
    await cloudflare.init();
  } catch (e) {
    print(e);
  }
  runApp(const App());
}