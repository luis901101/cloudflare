// Public entrypoint with conditional import
import 'package:cloudflare/src/utils/platform_stub/platform_stub.dart'
    if (dart.library.html) 'package:cloudflare/src/utils/platform_stub/platform_web.dart'
    if (dart.library.io) 'package:cloudflare/src/utils/platform_stub/platform_io.dart';

/// Utilities to check the current platform in pure Dart.
class PlatformUtils {
  static bool get isWeb => platformIsWeb;
}
