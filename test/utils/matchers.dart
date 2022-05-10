import 'package:cloudflare/cloudflare.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

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

bool printAndReturnOnFailure(String message) {
  printOnFailure(message);
  return false;
}

class ResponseMatcher extends GenericMatcher {
  ResponseMatcher() : super();

  @override
  bool matches(response, Map matchState) {
    if (response is! CloudflareHTTPResponse) {
      return false;
    }
    if (!response.isSuccessful) {
      // fail('Unsuccessful response: ${response.error?.toString()}');
      return printAndReturnOnFailure(
          'Unsuccessful response: ${response.error?.toString()}');
    }
    return true;
  }
}

class ImageMatcher extends ResponseMatcher {
  ImageMatcher() : super();

  @override
  bool matches(response, Map matchState) {
    super.matches(response, matchState);
    if (response is! CloudflareHTTPResponse<CloudflareImage?>) return false;
    return response.body != null && response.body!.variants.isNotEmpty;
  }
}

class StreamVideoMatcher extends ResponseMatcher {
  StreamVideoMatcher() : super();

  @override
  bool matches(response, Map matchState) {
    super.matches(response, matchState);
    if (response is! CloudflareHTTPResponse<CloudflareStreamVideo?>) return false;
    return response.body != null && response.body!.thumbnail.isNotEmpty &&
        response.body!.preview.isNotEmpty;
  }
}
