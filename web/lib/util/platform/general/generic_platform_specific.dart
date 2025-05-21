// web_platform_specific.dart
import 'dart:typed_data';

import 'package:balzanewsweb/interface/platform_interface.dart';


class GeneralUtil extends PlatformInterface {
  @override
  void useWebSpecificFeature() {
    print("This is a web-specific feature.");
  }

  @override
  bool get isPWAMode {
    return false;
  }

  @override
  int get statusBarHeight {
    return 0;
  }
}
