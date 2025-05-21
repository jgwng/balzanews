import 'package:balzanewsweb/util/platform_util.dart';
import 'package:web/web.dart';
extension UISizeNum on num {
  static const double targetWidth = 390;

  double get s {
    double screenWidth = document.documentElement?.clientWidth.toDouble() ?? targetWidth;
    if(screenWidth > targetWidth){
      screenWidth = targetWidth;
    }
    return toDouble() * (screenWidth)/targetWidth;
  }

  double get fs {
    if(PlatformUtil.isDesktopWeb){
      return toDouble();
    }
    return s;
  }
}
