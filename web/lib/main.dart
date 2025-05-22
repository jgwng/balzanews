
import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/helper/device_info_helper.dart';
import 'package:balzanewsweb/screens/home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main(){
  DeviceInfoHelper().init();
  runApp(DevNewsApp());
}

class DevNewsApp extends StatelessWidget {
  const DevNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        fontFamilyFallback: AppFonts.fontFamilyFallback
      ),
      home: HomeScreen(),
      scrollBehavior: CustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

