@JS()
library safe_area;

import 'dart:js_interop';

@JS('bottomInset')
external double bottomInset();

@JS('topInset')
external double topInset();

@JS('leftInset')
external double leftInset();

@JS('rightInset')
external double rightInset();
