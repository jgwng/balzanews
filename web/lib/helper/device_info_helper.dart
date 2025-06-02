import 'dart:html' as html;
import 'package:balzanewsweb/util/device_util.dart';
import 'package:balzanewsweb/util/platform_util.dart';

class DeviceInfoHelper{
  static final DeviceInfoHelper _instance = DeviceInfoHelper._internal();

  factory DeviceInfoHelper() {
    return _instance;
  }

  double? topPadding, leftPadding, rightPadding, bottomPadding;
  double? width, height;

  DeviceInfoHelper._internal() {}

  void init(){
    if(PlatformUtil.isDesktopWeb) return;

    bottomPadding = bottomInset();
    topPadding = topInset();
    leftPadding = leftInset();
    rightPadding = rightInset();

    width = html.window.outerWidth.toDouble();
    height = html.window.innerHeight?.toDouble();
  }


  void setWidth(double deviceWidth){
    width = deviceWidth;
  }

}