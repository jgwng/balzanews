import 'package:balzanewsweb/helper/app_theme_helper.dart';
import 'package:balzanewsweb/helper/device_info_helper.dart';
import 'package:balzanewsweb/helper/local_db_helper.dart';
import 'package:flutter/material.dart';

Future<void> bootstrap() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDB().init();
  DeviceInfoHelper().init();
  AppThemeHelper().init();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

