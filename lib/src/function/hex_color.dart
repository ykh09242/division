// from '#123456' or '123456' -> Color(0xFF123456)
import 'package:flutter/material.dart';

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(final String hexColor) {
    String newHexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      newHexColor = 'FF$newHexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}
