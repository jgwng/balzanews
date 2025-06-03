import 'package:balzanewsweb/helper/app_theme_helper.dart';
import 'package:balzanewsweb/helper/device_info_helper.dart';
import 'package:balzanewsweb/helper/local_db_helper.dart';
import 'package:balzanewsweb/util/platform_util.dart';
import 'package:flutter/material.dart';


Future<void> bootstrap() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(PlatformUtil.isDebugPWA){
    await LocalDBHelper().init();
    DeviceInfoHelper().init();
  }
  AppThemeHelper().init();
}



