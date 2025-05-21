
import 'package:balzanewsweb/util/common_util.dart';
import 'package:flutter/material.dart';

class AppFonts {
  static const String bold = 'Bold';
  static const String medium = 'Noto Sans KR';
  static const String emoji = 'NotoColorEmoji';
  static const List<String> fontFamilyFallback =  ['Noto Sans KR', 'Roboto'];
}
class AppThemes {
  AppThemes._();
  static const Color textColor = Color(0xff222222);
  static const Color backgroundColor = Color(0xFFFFFAFA);
  static const Color pointColor = Color(0xff2B6747);
  static const Color fontColor = Color(0xFF131214);

  static const Color disableColor = Color.fromRGBO(178, 178, 178, 1.0);
  static const Color noticeColor = Color.fromARGB(255, 77, 82, 86);
  static const Color hintColor = Color.fromARGB(255, 169, 175, 179);

  static const buttonTextColor = Color(0xFFF6F5EE);
  static const mobileBackgroundColor = Color.fromRGBO(238, 238, 241, 1.0);

  static final themeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppThemes.pointColor),
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    hoverColor: Colors.transparent,
    brightness: Brightness.light,
    //초기 StatusBar 색상 설정 되는 값
    primarySwatch: CommonUtil.createMaterialColor(AppThemes.backgroundColor),
    useMaterial3: false,
    fontFamilyFallback: AppFonts.fontFamilyFallback,
    scaffoldBackgroundColor: AppThemes.backgroundColor,
    canvasColor: AppThemes.backgroundColor,
  );
}
class AppStyles{
  static const TextStyle w500 = TextStyle(
    fontFamily: AppFonts.medium,
    color: AppThemes.fontColor,
    letterSpacing: -0.47,
  );
  static const TextStyle w700 = TextStyle(
    fontFamily: AppFonts.bold,
    color: AppThemes.fontColor,
    letterSpacing: -0.47,
  );
}
extension ColorExtension on Color {
  String toStatusHex() {
    return '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}