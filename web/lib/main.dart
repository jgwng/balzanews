import 'package:balzanewsweb/bootstrap.dart';
import 'package:balzanewsweb/core/routes.dart';
import 'package:balzanewsweb/helper/app_theme_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() async{
  await bootstrap();
  runApp(DevNewsApp());
}

class DevNewsApp extends StatelessWidget {
  const DevNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppThemeHelper.themeMode,
      builder: (_, mode, __) {
        return MaterialApp.router(
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
          theme: AppThemeHelper.light,
          darkTheme: AppThemeHelper.dark,
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          scrollBehavior: CustomScrollBehavior(),
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

