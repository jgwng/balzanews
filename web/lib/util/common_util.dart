import 'dart:html' as html;

import 'package:flutter/material.dart';

void runJSFunction(String fnName) {
// Create a script element
  final script = html.ScriptElement()
    ..type = 'application/javascript'
    ..innerHtml = '$fnName();';

// Append the script to the document body to execute it
  html.document.body?.children.add(script);
// Remove the script element after execution if necessary
  script.remove();
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final double r = color.r, g = color.g, b = color.b;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      (r + ((ds < 0 ? r : (255 - r)) * ds).round()).toInt(),
      (g + ((ds < 0 ? g : (255 - g)) * ds).round()).toInt(),
      (b + ((ds < 0 ? b : (255 - b)) * ds).round()).toInt(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
