
import 'dart:io';

import 'package:cloudflare/cloudflare.dart';

/// Make sure to set all of this environment variables before running tests
///
/// export CLOUDFLARE_API_URL=https://api.cloudflare.com/client/v4
/// export CLOUDFLARE_ACCOUNT_ID=can74t5a7n4ym9aw4y54875
/// export CLOUDFLARE_TOKEN=HaE_239h89283fFH7F7ffF3f3fo3nf1n
///
final String? apiUrl = Platform.environment['CLOUDFLARE_API_URL'];
final String? accountId = Platform.environment['CLOUDFLARE_ACCOUNT_ID'];
final String? token = Platform.environment['CLOUDFLARE_TOKEN'];

Cloudflare cloudflare = Cloudflare(accountId: '', token: '');

Future<void> init() async {

  // print(apiUrl);
  // print(accountId);
  // print(token);

  if(accountId == null) throw Exception("accountId can't be null");
  if(token == null) throw Exception("token can't be null");

  if(cloudflare.isInitialized) return;

  cloudflare = Cloudflare(
    apiUrl: apiUrl,
    accountId: accountId!,
    token: token,
  );
  await cloudflare.init();
}
