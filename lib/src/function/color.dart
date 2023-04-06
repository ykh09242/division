import 'package:division/src/function/hex_color.dart';
import 'package:flutter/material.dart';

/// Returns [Color].
///
/// [r], [g] and [b] must not exceed 255.
///
/// ```dart
/// ..backgroundColor(rgb(34, 29, 189));
/// ```
Color rgb(final int r, final int g, final int b) {
  return Color.fromRGBO(r, g, b, 1.0);
}

/// Returns [Color].
///
/// [r], [g] and [b] must not exceed 255.
///
/// ```dart
/// ..backgroundColor(rgba(34, 29, 189, 0.7));
/// ```
Color rgba(
  final int r,
  final int g,
  final int b, [
  final double opacity = 1.0,
]) {
  return Color.fromRGBO(r, g, b, opacity);
}

/// 6 digit hex color. The use if `#` is not required but optional.
/// ```dart
/// hex('f5f5f5') // or
/// hex('#f5f5f5')
/// ```
Color hex(final String xxxxxx) {
  return HexColor(xxxxxx);
}
