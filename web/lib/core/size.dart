import 'package:balzanewsweb/util/platform_util.dart';
import 'dart:html' as html;
extension UISizeNum on num {
  static const double targetWidth = 390;

  double get s {
    double screenWidth = html.document.documentElement?.clientWidth.toDouble() ?? targetWidth;
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
