import 'package:balzanewsweb/firebase_options.dart';
import 'package:balzanewsweb/helper/app_theme_helper.dart';
import 'package:balzanewsweb/helper/device_info_helper.dart';
import 'package:balzanewsweb/helper/local_db_helper.dart';
import 'package:balzanewsweb/util/platform_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

Future<void> bootstrap() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if(PlatformUtil.isDebugPWA){
    await LocalDBHelper().init();
    DeviceInfoHelper().init();
  }
  AppThemeHelper().init();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

