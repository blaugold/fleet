import 'package:flutter/widgets.dart';

import 'framework.dart';

/// A version of [SizedBox] that supports state-based animation with [Animated].
class ASizedBox extends StatefulWidget {
  /// Creates a version of [SizedBox] that supports state-based animation with
  /// [Animated].
  const ASizedBox({
    super.key,
    required this.height,
    required this.width,
    this.child,
  });

  /// See [SizedBox.fromSize].
  ASizedBox.fromSize({super.key, this.child, Size? size})
      : height = size?.height,
        width = size?.width;

  /// See [SizedBox.square].
  const ASizedBox.square({super.key, this.child, double? dimension})
      : height = dimension,
        width = dimension;

  /// See [SizedBox.height].
  final double? height;

  /// See [SizedBox.width].
  final double? width;

  /// See [ProxyWidget.child].
  final Widget? child;

  @override
  State<ASizedBox> createState() => _ASizedBoxState();
}

class _ASizedBoxState extends AnimatedValueState<ASizedBox> {
  late final _height = OptionalAnimatedValue(widget.height, vsync: this);
  late final _width = OptionalAnimatedValue(widget.width, vsync: this);

  @override
  void updateAnimatedValues() {
    _height.value = widget.height;
    _width.value = widget.width;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height.animatedValue,
      width: _width.animatedValue,
      child: widget.child,
    );
  }
}

/// A version of [ColoredBox] that supports state-based animation with
/// [Animated].
class AColoredBox extends StatefulWidget {
  /// Creates a version of [ColoredBox] that supports state-based animation with
  /// [Animated].
  const AColoredBox({super.key, required this.color, this.child});

  /// See [ColoredBox.color].
  final Color color;

  /// See [ProxyWidget.child].
  final Widget? child;

  @override
  State<AColoredBox> createState() => _AColoredBoxState();
}

class _AColoredBoxState extends AnimatedValueState<AColoredBox> {
  late final _color = AnimatedColor(widget.color, vsync: this);

  @override
  void updateAnimatedValues() {
    _color.value = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _color.animatedValue,
      child: widget.child,
    );
  }
}

/// A version of [Align] that supports state-based animation with [Animated].
class AAlign extends StatefulWidget {
  /// Creates a version of [Align] that supports state-based animation with
  /// [Animated].
  const AAlign({
    super.key,
    this.alignment = Alignment.center,
    this.widthFactor,
    this.heightFactor,
    this.child,
  });

  /// See [Align.alignment].
  final AlignmentGeometry alignment;

  /// See [Align.widthFactor].
  final double? widthFactor;

  /// See [Align.heightFactor].
  final double? heightFactor;

  /// See [ProxyWidget.child].
  final Widget? child;

  @override
  State<AAlign> createState() => _AAlignState();
}

class _AAlignState extends AnimatedValueState<AAlign> {
  late final _alignment = AnimatedValue(
    widget.alignment,
    tweenFactory: AlignmentTween.new,
    vsync: this,
  );
  late final _heightFactor = OptionalAnimatedValue(
    widget.heightFactor,
    vsync: this,
  );
  late final _widthFactor = OptionalAnimatedValue(
    widget.widthFactor,
    vsync: this,
  );

  @override
  void updateAnimatedValues() {
    _alignment.value = widget.alignment;
    _heightFactor.value = widget.heightFactor;
    _widthFactor.value = widget.widthFactor;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _alignment.animatedValue,
      widthFactor: _widthFactor.animatedValue,
      heightFactor: _heightFactor.animatedValue,
      child: widget.child,
    );
  }
}
