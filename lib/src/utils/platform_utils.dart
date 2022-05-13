import 'dart:io';

class PlatformUtils {
  /// Workaround to know if dart code is running on web
  static bool get isWeb {
    try {
      Platform.isAndroid;
      return false;
    } catch (e) {
      print(e);
    }
    return true;
  }

  static bool get isIOS {
    try {
      return Platform.isIOS;
    } catch (e) {
      print(e);
    }
    return false;
  }

  static bool get isAndroid {
    try {
      return Platform.isAndroid;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
