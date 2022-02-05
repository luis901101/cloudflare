
import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare/src/base_api/c_response.dart';
import 'package:test/expect.dart';

class GenericMatcher extends Matcher {

  bool Function(dynamic item, Map matchState)? onMatches;
  Description Function(Description description)? onDescribe;

  GenericMatcher({this.onMatches, this.onDescribe});

  @override
  bool matches(dynamic item, Map matchState) =>
      onMatches?.call(item, matchState) ?? false;

  @override
  Description describe(Description description) =>
      onDescribe?.call(description) ?? description;
}

class ImageMatcher extends GenericMatcher {

  ImageMatcher() : super(
    onMatches: (response, matchState) {
      if(response is! CResponse<CloudflareImage>) return false;
      return response.isSuccessful &&
          response.body != null &&
          response.body!.variants.isNotEmpty;
    }
  );
}