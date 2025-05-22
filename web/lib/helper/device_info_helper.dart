import 'package:balzanewsweb/util/device_util.dart';

class DeviceInfoHelper{
  static final DeviceInfoHelper _instance = DeviceInfoHelper._internal();

  factory DeviceInfoHelper() {
    return _instance;
  }
  double? bottomPadding;
  double? topPadding;
  double? leftPadding;
  double? rightPadding;

  DeviceInfoHelper._internal() {}

  void init(){
    bottomPadding = bottomInset();
    topPadding = topInset();
    leftPadding = leftInset();
    rightPadding = rightInset();
  }

}