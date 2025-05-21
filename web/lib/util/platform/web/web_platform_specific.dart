// web_platform_specific.dart
import 'package:balzanewsweb/interface/platform_interface.dart';
import 'dart:html' as html;

class WebUtil extends PlatformInterface {
  @override
  void useWebSpecificFeature() {
    // Use dart:html features here
    html.window.alert("This is a web-specific feature.");
  }

  @override
  bool get isPWAMode {
    const mqStandAlone = '(display-mode: standalone)';
    if (html.window.matchMedia(mqStandAlone).matches) {
      return true;
    } else {
      return false;
    }
  }

  @override
  int get statusBarHeight {
    var windowHeight = html.window.innerHeight;
    var documentHeight = html.document.documentElement?.clientHeight;
    var statusbar = (windowHeight ?? 0) - (documentHeight ?? 0);
    return statusbar;
  }
}
