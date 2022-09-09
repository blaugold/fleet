import 'dart:math';

import 'package:flutter/animation.dart';

/// Mirrors a [curve] around `y = 0.5`.
class MidpointMirroredCurve extends Curve {
  const MidpointMirroredCurve(this.curve);

  final Curve curve;

  @override
  double transform(double t) => 1 + curve.transform(t) * -1;
}

class SineCurve extends Curve {
  const SineCurve([this.period = 1]);

  final double period;

  @override
  double transform(double t) => sin(t * pi * 2 * period);
}

class CosineCurve extends Curve {
  const CosineCurve([this.period = 1]);

  final double period;

  @override
  double transform(double t) => cos(t * pi * 2 * period);
}

extension CurveExtension on Curve {
  Curve get midpointMirrored => MidpointMirroredCurve(this);
}
