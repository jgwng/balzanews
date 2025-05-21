import 'package:balzanewsweb/interface/platform_interface.dart';
import 'package:balzanewsweb/util/platform/general/generic_platform_specific.dart';
import 'package:balzanewsweb/util/platform/web/web_platform_specific.dart';

import 'package:flutter/foundation.dart';

class PlatformUtil {
  static PlatformInterface get _platformInterface =>
      (kIsWeb) ? WebUtil() : GeneralUtil();

  static bool get isWeb {
    return kIsWeb;
  }

  static bool get isIOS{
    return defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS;
  }

  static bool get isAndroid{
    return defaultTargetPlatform == TargetPlatform.android;
  }

  static bool get isIOSWeb {
    bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;
    return isWeb == true && isIOS == true;
  }

  static bool get isAOSWeb {
    bool isAOS = defaultTargetPlatform == TargetPlatform.android;
    return isWeb == true && isAOS == true;
  }

  static bool get isIOSApp {
    bool isMobile = kIsWeb == false;
    bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;
    return isMobile == true && isIOS == true;
  }

  static bool get isAOSApp {
    bool isMobile = kIsWeb == false;
    bool isAOS = defaultTargetPlatform == TargetPlatform.android;
    return isMobile == true && isAOS == true;
  }

  static bool get isDesktopWeb {
    bool isWeb = kIsWeb;
    bool isAOS = defaultTargetPlatform == TargetPlatform.android;
    bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;
    return isWeb == true && isAOS == false && isIOS == false;
  }

  static bool get isPWA {
    return _platformInterface.isPWAMode;
  }

}
