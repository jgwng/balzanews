
import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/helper/app_theme_helper.dart';
import 'package:balzanewsweb/helper/device_info_helper.dart';
import 'package:balzanewsweb/helper/local_db_helper.dart';
import 'package:balzanewsweb/screens/home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDB().init();
  DeviceInfoHelper().init();
  runApp(DevNewsApp());
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class DevNewsApp extends StatelessWidget {
  const DevNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppThemeHelper.themeMode,
      builder: (_, mode, __) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          theme: AppThemeHelper.light,
          darkTheme: AppThemeHelper.dark,
          themeMode: mode,
            home: HomeScreen(),
            scrollBehavior: CustomScrollBehavior(),
            debugShowCheckedModeBanner: false,
        );
      },
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

