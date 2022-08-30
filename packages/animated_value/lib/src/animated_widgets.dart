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
  Widget buildWithAnimatedValues(BuildContext context) {
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
  Widget buildWithAnimatedValues(BuildContext context) {
    return ColoredBox(
      color: _color.animatedValue,
      child: widget.child,
    );
  }
}
