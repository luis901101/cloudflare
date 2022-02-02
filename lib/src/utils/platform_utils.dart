
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

  static bool get isIOs => Platform.isIOS;
  static bool get isAndroid => Platform.isAndroid;
}