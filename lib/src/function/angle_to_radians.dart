import 'dart:math';

import 'package:division/src/style.dart';

double angleToRadians(final double value, final AngleFormat angleFormat) {
  double newValue = value;
  switch (angleFormat) {
    case AngleFormat.radians:
      break;
    case AngleFormat.cycles:
      newValue = value * 2 * pi;
      break;
    case AngleFormat.degree:
      newValue = (value / 360) * 2 * pi;
      break;
  }
  return newValue;
}
