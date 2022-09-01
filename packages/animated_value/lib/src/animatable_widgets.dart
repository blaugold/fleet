import 'package:flutter/widgets.dart';

import 'animatable_widget.dart';

/// Animatable version of [Align].
class AAlign extends StatefulWidget {
  /// Creates an animatable version of [Align].
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

class _AAlignState extends AnimatableState<AAlign> {
  late final _alignment = AnimatableAlignmentGeometry(
    widget.alignment,
    state: this,
  );
  late final _heightFactor = OptionalAnimatableDouble(
    widget.heightFactor,
    state: this,
  );
  late final _widthFactor = OptionalAnimatableDouble(
    widget.widthFactor,
    state: this,
  );

  @override
  void updateAnimatableParameters() {
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

/// Animatable version of [ColoredBox].
class AColoredBox extends StatefulWidget {
  /// Creates an animatable version of [ColoredBox].
  const AColoredBox({super.key, required this.color, this.child});

  /// See [ColoredBox.color].
  final Color color;

  /// See [ProxyWidget.child].
  final Widget? child;

  @override
  State<AColoredBox> createState() => _AColoredBoxState();
}

class _AColoredBoxState extends AnimatableState<AColoredBox> {
  late final _color = AnimatableColor(widget.color, state: this);

  @override
  void updateAnimatableParameters() {
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

/// Animatable version of [Container].
class AContainer extends StatefulWidget {
  /// Creates an animatable version of [Container].
  AContainer({
    super.key,
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.margin,
    this.transform,
    this.transformAlignment,
    double? width,
    double? height,
    BoxConstraints? constraints,
    this.clipBehavior = Clip.none,
    this.child,
  }) : constraints = (width != null || height != null)
            ? constraints?.tighten(width: width, height: height) ??
                BoxConstraints.tightFor(width: width, height: height)
            : constraints;

  /// See [Container.alignment].
  final AlignmentGeometry? alignment;

  /// See [Container.padding].
  final EdgeInsetsGeometry? padding;

  /// See [Container.color].
  final Color? color;

  /// See [Container.decoration].
  final Decoration? decoration;

  /// See [Container.foregroundDecoration].
  final Decoration? foregroundDecoration;

  /// See [Container.constraints].
  final BoxConstraints? constraints;

  /// See [Container.margin].
  final EdgeInsetsGeometry? margin;

  /// See [Container.transform].
  final Matrix4? transform;

  /// See [Container.transformAlignment].
  final AlignmentGeometry? transformAlignment;

  /// See [Container.clipBehavior].
  final Clip clipBehavior;

  /// See [Container.child].
  final Widget? child;

  @override
  State<AContainer> createState() => _AContainerState();
}

class _AContainerState extends AnimatableState<AContainer> {
  late final _alignment = OptionalAnimatableAlignmentGeometry(
    widget.alignment,
    state: this,
  );
  late final _padding = OptionalAnimatableEdgeInsetsGeometry(
    widget.padding,
    state: this,
  );
  late final _color = OptionalAnimatableColor(
    widget.color,
    state: this,
  );
  late final _decoration = OptionalAnimatableDecoration(
    widget.decoration,
    state: this,
  );
  late final _foregroundDecoration = OptionalAnimatableDecoration(
    widget.foregroundDecoration,
    state: this,
  );
  late final _constraints = OptionalAnimatableBoxConstraints(
    widget.constraints,
    state: this,
  );
  late final _margin = OptionalAnimatableEdgeInsetsGeometry(
    widget.margin,
    state: this,
  );
  late final _transform = OptionalAnimatableMatrix4(
    widget.transform,
    state: this,
  );
  late final _transformAlignment = OptionalAnimatableAlignmentGeometry(
    widget.transformAlignment,
    state: this,
  );

  @override
  void updateAnimatableParameters() {
    _alignment.value = widget.alignment;
    _padding.value = widget.padding;
    _color.value = widget.color;
    _decoration.value = widget.decoration;
    _foregroundDecoration.value = widget.foregroundDecoration;
    _constraints.value = widget.constraints;
    _margin.value = widget.margin;
    _transform.value = widget.transform;
    _transformAlignment.value = widget.transformAlignment;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: _alignment.animatedValue,
      padding: _padding.animatedValue,
      color: _color.animatedValue,
      decoration: _decoration.animatedValue,
      foregroundDecoration: _foregroundDecoration.animatedValue,
      constraints: _constraints.animatedValue,
      margin: _margin.animatedValue,
      transform: _transform.animatedValue,
      transformAlignment: _transformAlignment.animatedValue,
      clipBehavior: widget.clipBehavior,
      child: widget.child,
    );
  }
}

/// Animatable version of [SizedBox].
class ASizedBox extends StatefulWidget {
  /// Creates an animatable version of [SizedBox].
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

class _ASizedBoxState extends AnimatableState<ASizedBox> {
  late final _height = OptionalAnimatableDouble(widget.height, state: this);
  late final _width = OptionalAnimatableDouble(widget.width, state: this);

  @override
  void updateAnimatableParameters() {
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
