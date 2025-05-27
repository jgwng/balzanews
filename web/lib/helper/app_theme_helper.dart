import 'package:balzanewsweb/core/consts.dart';
import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/util/common_util.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:js' as js;
class AppThemeHelper{
  static final AppThemeHelper instance = AppThemeHelper._internal();
  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);
  static ValueNotifier<bool> current = ValueNotifier(true);
  factory AppThemeHelper() => instance;

  static void change() {
    switch (themeMode.value) {
      case ThemeMode.light:
        themeMode.value = ThemeMode.dark;
        current.value = false;
        html.window.localStorage[AppKeys.IS_LIGHT_MODE] = 'false';
        js.context.callMethod('setThemeColor',['#1C1C20']);
        js.context.callMethod('setThemeData',['dark']);
        break;
      case ThemeMode.dark:
        themeMode.value = ThemeMode.light;
        current.value = true;
        html.window.localStorage[AppKeys.IS_LIGHT_MODE] = 'false';
        js.context.callMethod('setThemeColor',['#F9F9F9']);
        js.context.callMethod('setThemeData',['light']);
        break;
      default:
    }
  }

  AppThemeHelper._internal();

  void init() {
    final value = html.window.localStorage[AppKeys.IS_LIGHT_MODE] ?? 'true';
    if (value == 'true') {
      themeMode.value = ThemeMode.light;
      current.value = true;
    } else {
      themeMode.value = ThemeMode.dark;
      current.value = false;
      js.context.callMethod('setThemeColor',['#1C1C20']);
    }
  }
  static final ThemeData light = ThemeData(
    primaryColorLight: const Color(0xFFF8F8FF),
    primaryColorDark: const Color(0xff222222),
    secondaryHeaderColor: const Color(0xFFEAEBED),
    scaffoldBackgroundColor: const Color(0xFFF8F8FF),
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    focusColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    fontFamilyFallback: AppFonts.fontFamilyFallback,
    canvasColor: Colors.red,
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFF8F8FF)
    ),
    primarySwatch: createMaterialColor(Color(0xFFF8F8FF)),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.light(
      surface:Color(0xFFF9F9F9),
      onSurface: Color(0xFF1C1C20),
      surfaceDim: AppThemes.fontColor,
      surfaceBright :Color(0xFFA0A0A0)
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.black),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontSize: 12, // Set your desired font size
              fontWeight: FontWeight.bold, // Set your desired font weight
              color: Colors.white, // Set your desired text color
            ),
          ),
        )),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.black,
      textTheme: ButtonTextTheme.normal,
    ),
    textSelectionTheme: const TextSelectionThemeData(selectionHandleColor: Color(0xff222222)),
  );

  static final ThemeData dark = ThemeData(
      scaffoldBackgroundColor: Color(0xFF1C1C20),
      primaryColorDark: const Color(0xFF1C1C20),
      primaryColorLight: const Color(0xff222222),
      primarySwatch: createMaterialColor(Color(0xFF1C1C20)),
      secondaryHeaderColor: const Color.fromRGBO(40, 40, 40, 1.0),
      splashFactory: NoSplash.splashFactory,
      fontFamilyFallback: AppFonts.fontFamilyFallback,
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.white,
        textTheme: ButtonTextTheme.normal,
      ),
      appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1C1C20)
      ),
      colorScheme: ColorScheme.dark(
        surface: Color(0xFF1C1C20),
        onSurface: Color(0xFFF9F9F9),
        surfaceDim: Color(0xFFF8F9FE),
        surfaceBright: Color(0xFFCCCCCC),
      ),
      textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor: Color.fromRGBO(239, 241, 243, 1.0)),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.white),
            foregroundColor: WidgetStateProperty.all(Colors.black),
            textStyle: WidgetStateProperty.all(
              const TextStyle(
                fontSize: 12, // Set your desired font size
                fontWeight: FontWeight.bold, // Set your desired font weight
                color: Colors.black, // Set your desired text color
              ),
            ),
          )),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromRGBO(22, 22, 22, 1.0),
        selectedItemColor: Color.fromRGBO(237, 237, 237, 1.0),
        unselectedItemColor: Color.fromRGBO(111, 111, 111, 1.0),
      ));
}