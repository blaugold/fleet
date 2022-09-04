import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'animatable_widget.dart';

/// Animatable version of [Align].
///
/// {@category Animatable Flutter widget}
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
///
/// {@category Animatable Flutter widget}
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
///
/// {@category Animatable Flutter widget}
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

/// Animatable version of [Opacity].
///
/// {@category Animatable Flutter widget}
class AOpacity extends StatefulWidget {
  /// Creates an animatable version of [Opacity].
  const AOpacity({
    super.key,
    required this.opacity,
    this.alwaysIncludeSemantics = false,
    this.child,
  });

  /// See [Opacity.opacity].
  final double opacity;

  /// See [Opacity.alwaysIncludeSemantics].
  final bool alwaysIncludeSemantics;

  /// See [ProxyWidget.child].
  final Widget? child;

  @override
  State<AOpacity> createState() => _AOpacityState();
}

class _AOpacityState extends AnimatableState<AOpacity> {
  late final _opacity = AnimatableDouble(widget.opacity, state: this);

  @override
  void updateAnimatableParameters() {
    _opacity.value = widget.opacity;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacity.animatedValue,
      alwaysIncludeSemantics: widget.alwaysIncludeSemantics,
      child: widget.child,
    );
  }
}

/// Animatable version of [Padding].
///
/// {@category Animatable Flutter widget}
class APadding extends StatefulWidget {
  /// Creates an animatable version of [Padding].
  const APadding({super.key, required this.padding, this.child});

  /// See [Padding.padding].
  final EdgeInsetsGeometry padding;

  /// See [ProxyWidget.child].
  final Widget? child;

  @override
  State<APadding> createState() => _APaddingState();
}

class _APaddingState extends AnimatableState<APadding> {
  late final _padding = AnimatableEdgeInsetsGeometry(
    widget.padding,
    state: this,
  );

  @override
  void updateAnimatableParameters() {
    _padding.value = widget.padding;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding.animatedValue,
      child: widget.child,
    );
  }
}

/// Animatable version of [Positioned].
///
/// {@category Animatable Flutter widget}
class APositioned extends StatefulWidget {
  /// Creates an animatable version of [Positioned].
  const APositioned({
    super.key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    required this.child,
  })  : assert(left == null || right == null || width == null),
        assert(top == null || bottom == null || height == null);

  /// See [Positioned.fromRect].
  APositioned.fromRect({
    super.key,
    required Rect rect,
    required this.child,
  })  : left = rect.left,
        top = rect.top,
        width = rect.width,
        height = rect.height,
        right = null,
        bottom = null;

  /// See [Positioned.fromRelativeRect].
  APositioned.fromRelativeRect({
    super.key,
    required RelativeRect rect,
    required this.child,
  })  : left = rect.left,
        top = rect.top,
        right = rect.right,
        bottom = rect.bottom,
        width = null,
        height = null;

  /// See [Positioned.fill].
  const APositioned.fill({
    super.key,
    this.left = 0.0,
    this.top = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
    required this.child,
  })  : width = null,
        height = null;

  /// See [Positioned.directional].
  factory APositioned.directional({
    Key? key,
    required TextDirection textDirection,
    double? start,
    double? top,
    double? end,
    double? bottom,
    double? width,
    double? height,
    required Widget child,
  }) {
    double? left;
    double? right;
    switch (textDirection) {
      case TextDirection.rtl:
        left = end;
        right = start;
        break;
      case TextDirection.ltr:
        left = start;
        right = end;
        break;
    }
    return APositioned(
      key: key,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: child,
    );
  }

  /// See [Positioned.left].
  final double? left;

  /// See [Positioned.top].
  final double? top;

  /// See [Positioned.right].
  final double? right;

  /// See [Positioned.bottom].
  final double? bottom;

  /// See [Positioned.width].
  final double? width;

  /// See [Positioned.height].
  final double? height;

  /// See [ProxyWidget.child].
  final Widget child;

  @override
  State<APositioned> createState() => _APositionedState();
}

class _APositionedState extends AnimatableState<APositioned> {
  late final _left = OptionalAnimatableDouble(widget.left, state: this);
  late final _top = OptionalAnimatableDouble(widget.top, state: this);
  late final _right = OptionalAnimatableDouble(widget.right, state: this);
  late final _bottom = OptionalAnimatableDouble(widget.bottom, state: this);
  late final _width = OptionalAnimatableDouble(widget.width, state: this);
  late final _height = OptionalAnimatableDouble(widget.height, state: this);

  @override
  void updateAnimatableParameters() {
    _left.value = widget.left;
    _top.value = widget.top;
    _right.value = widget.right;
    _bottom.value = widget.bottom;
    _width.value = widget.width;
    _height.value = widget.height;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _left.animatedValue,
      top: _top.animatedValue,
      right: _right.animatedValue,
      bottom: _bottom.animatedValue,
      width: _width.animatedValue,
      height: _height.animatedValue,
      child: widget.child,
    );
  }
}

/// Animatable version of [PositionedDirectional].
///
/// {@category Animatable Flutter widget}
class APositionedDirectional extends StatelessWidget {
  /// Creates an animatable version of [PositionedDirectional].
  const APositionedDirectional({
    super.key,
    this.start,
    this.top,
    this.end,
    this.bottom,
    this.width,
    this.height,
    required this.child,
  });

  /// See [PositionedDirectional.start].
  final double? start;

  /// See [PositionedDirectional.top].
  final double? top;

  /// See [PositionedDirectional.end].
  final double? end;

  /// See [PositionedDirectional.bottom].
  final double? bottom;

  /// See [PositionedDirectional.width].
  final double? width;

  /// See [PositionedDirectional.height].
  final double? height;

  /// See [PositionedDirectional.child].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return APositioned.directional(
      textDirection: Directionality.of(context),
      start: start,
      top: top,
      end: end,
      bottom: bottom,
      width: width,
      height: height,
      child: child,
    );
  }
}

/// Animatable version of [SizedBox].
///
/// {@category Animatable Flutter widget}
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

/// Animatable version of [SliverOpacity].
///
/// {@category Animatable Flutter widget}
class ASliverOpacity extends StatefulWidget {
  /// Creates an animatable version of [SliverOpacity].
  const ASliverOpacity({
    super.key,
    required this.opacity,
    this.alwaysIncludeSemantics = false,
    this.sliver,
  });

  /// See [SliverOpacity.opacity].
  final double opacity;

  /// See [SliverOpacity.alwaysIncludeSemantics].
  final bool alwaysIncludeSemantics;

  /// See [ProxyWidget.child].
  final Widget? sliver;

  @override
  State<ASliverOpacity> createState() => _ASliverOpacityState();
}

class _ASliverOpacityState extends AnimatableState<ASliverOpacity> {
  late final _opacity = AnimatableDouble(widget.opacity, state: this);

  @override
  void updateAnimatableParameters() {
    _opacity.value = widget.opacity;
  }

  @override
  Widget build(BuildContext context) {
    return SliverOpacity(
      opacity: _opacity.animatedValue,
      alwaysIncludeSemantics: widget.alwaysIncludeSemantics,
      sliver: widget.sliver,
    );
  }
}

/// Animatable version of [SliverPadding].
///
/// {@category Animatable Flutter widget}
class ASliverPadding extends StatefulWidget {
  /// Creates an animatable version of [SliverPadding].
  const ASliverPadding({super.key, required this.padding, this.sliver});

  /// See [SliverPadding.padding].
  final EdgeInsetsGeometry padding;

  /// See [ProxyWidget.child].
  final Widget? sliver;

  @override
  State<ASliverPadding> createState() => _ASliverPaddingState();
}

class _ASliverPaddingState extends AnimatableState<ASliverPadding> {
  late final _padding = AnimatableEdgeInsetsGeometry(
    widget.padding,
    state: this,
  );

  @override
  void updateAnimatableParameters() {
    _padding.value = widget.padding;
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: _padding.animatedValue,
      sliver: widget.sliver,
    );
  }
}

/// Animatable version of [Transform].
///
/// {@category Animatable Flutter widget}
abstract class ATransform extends StatefulWidget {
  /// Creates an animatable version of [Transform].
  const factory ATransform({
    Key? key,
    required Matrix4 transform,
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests,
    FilterQuality? filterQuality,
    Widget? child,
  }) = _ATransform;

  /// Creates an animatable version of [Transform.rotate].
  const factory ATransform.rotate({
    Key? key,
    required double angle,
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests,
    FilterQuality? filterQuality,
    Widget? child,
  }) = _ATransformRotate;

  /// Creates an animatable version of [Transform.translate].
  const factory ATransform.translate({
    Key? key,
    required Offset offset,
    bool transformHitTests,
    FilterQuality? filterQuality,
    Widget? child,
  }) = _ATransformTranslate;

  /// Creates an animatable version of [Transform.scale].
  const factory ATransform.scale({
    Key? key,
    double? scale,
    double? scaleX,
    double? scaleY,
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests,
    FilterQuality? filterQuality,
    Widget? child,
  }) = _ATransformScale;

  const ATransform._({super.key});

  /// See [Transform.transform].
  Matrix4 get transform;

  /// See [Transform.origin].
  Offset? get origin;

  /// See [Transform.alignment].
  AlignmentGeometry? get alignment;

  /// See [Transform.transformHitTests].
  bool get transformHitTests;

  /// See [Transform.filterQuality].
  FilterQuality? get filterQuality;

  /// See [ProxyWidget.child].
  Widget? get child;
}

abstract class _ATransformBase extends ATransform {
  const _ATransformBase({
    super.key,
    this.origin,
    this.alignment,
    this.transformHitTests = true,
    this.filterQuality,
    this.child,
  }) : super._();

  @override
  final Offset? origin;

  @override
  final AlignmentGeometry? alignment;

  @override
  final bool transformHitTests;

  @override
  final FilterQuality? filterQuality;

  @override
  final Widget? child;
}

abstract class _ATransformBaseState<T extends _ATransformBase>
    extends AnimatableState<T> {
  late final _origin = OptionalAnimatableObject(
    widget.origin,
    state: this,
  );
  late final _alignment = OptionalAnimatableAlignmentGeometry(
    widget.alignment,
    state: this,
  );

  bool get _useFilterQuality;

  Matrix4 get _transform;

  @override
  void updateAnimatableParameters() {
    _origin.value = widget.origin;
    _alignment.value = widget.alignment;
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: _transform,
      alignment: _alignment.animatedValue,
      transformHitTests: widget.transformHitTests,
      filterQuality: _useFilterQuality ? widget.filterQuality : null,
      child: widget.child,
    );
  }
}

extension on AnimatableParameter<void> {
  bool get useFilterQuality {
    // The ImageFilter layer created by setting filterQuality will introduce
    // a saveLayer call. This is usually worthwhile when animating the layer,
    // but leaving it in the layer tree before the animation has started or
    // after it has finished significantly hurts performance.
    final animationStatus = this.animationStatus;
    if (animationStatus == null) {
      return false;
    }
    switch (animationStatus) {
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        return true;
      case AnimationStatus.completed:
      case AnimationStatus.dismissed:
        return false;
    }
  }
}

abstract class _ASingleInputTransform<T> extends _ATransformBase {
  const _ASingleInputTransform({
    super.key,
    required this.input,
    super.origin,
    super.alignment,
    super.transformHitTests,
    super.filterQuality,
    super.child,
  }) : super();

  AnimatableParameter<T> createInputParameter(
    T value, {
    required AnimatableStateMixin state,
  });

  Matrix4 computeTransform(T input);

  final T input;

  @override
  Matrix4 get transform => computeTransform(input);

  @override
  State<_ASingleInputTransform<T>> createState() => _ASingInputTransformState();
}

class _ASingInputTransformState<T>
    extends _ATransformBaseState<_ASingleInputTransform<T>> {
  late final _input = widget.createInputParameter(widget.input, state: this);

  @override
  bool get _useFilterQuality => _input.useFilterQuality;

  @override
  Matrix4 get _transform => widget.computeTransform(_input.animatedValue);

  @override
  void updateAnimatableParameters() {
    super.updateAnimatableParameters();
    _input.value = widget.input;
  }
}

class _ATransform extends _ASingleInputTransform<Matrix4> {
  const _ATransform({
    super.key,
    required Matrix4 transform,
    super.origin,
    super.alignment,
    super.transformHitTests,
    super.filterQuality,
    super.child,
  }) : super(input: transform);

  @override
  AnimatableParameter<Matrix4> createInputParameter(
    Matrix4 value, {
    required AnimatableStateMixin state,
  }) =>
      AnimatableMatrix4(value, state: state);

  @override
  Matrix4 computeTransform(Matrix4 transform) => transform;
}

class _ATransformRotate extends _ASingleInputTransform<double> {
  const _ATransformRotate({
    super.key,
    required double angle,
    super.origin,
    super.alignment = Alignment.center,
    super.transformHitTests,
    super.filterQuality,
    super.child,
  }) : super(input: angle);

  @override
  AnimatableParameter<double> createInputParameter(
    double value, {
    required AnimatableStateMixin state,
  }) =>
      AnimatableDouble(value, state: state);

  @override
  Matrix4 computeTransform(double transformInput) =>
      _computeRotation(transformInput);

  // Computes a rotation matrix for an angle in radians, attempting to keep
  // rotations at integral values for angles of 0, π/2, π, 3π/2.
  static Matrix4 _computeRotation(double radians) {
    assert(
      radians.isFinite,
      'Cannot compute the rotation matrix for a non-finite angle: $radians',
    );
    if (radians == 0.0) {
      return Matrix4.identity();
    }
    final sin = math.sin(radians);
    if (sin == 1.0) {
      return _createZRotation(1, 0);
    }
    if (sin == -1.0) {
      return _createZRotation(-1, 0);
    }
    final cos = math.cos(radians);
    if (cos == -1.0) {
      return _createZRotation(0, -1);
    }
    return _createZRotation(sin, cos);
  }

  static Matrix4 _createZRotation(double sin, double cos) {
    final result = Matrix4.zero();
    result.storage[0] = cos;
    result.storage[1] = sin;
    result.storage[4] = -sin;
    result.storage[5] = cos;
    result.storage[10] = 1.0;
    result.storage[15] = 1.0;
    return result;
  }
}

class _ATransformTranslate extends _ASingleInputTransform<Offset> {
  const _ATransformTranslate({
    super.key,
    required Offset offset,
    super.transformHitTests,
    super.filterQuality,
    super.child,
  }) : super(input: offset);

  @override
  AnimatableParameter<Offset> createInputParameter(
    Offset value, {
    required AnimatableStateMixin state,
  }) =>
      AnimatableObject(value, state: state);

  @override
  Matrix4 computeTransform(Offset transformInput) =>
      Matrix4.translationValues(transformInput.dx, transformInput.dy, 0);
}

class _ATransformScale extends _ATransformBase {
  const _ATransformScale({
    super.key,
    this.scale,
    this.scaleX,
    this.scaleY,
    super.origin,
    super.alignment = Alignment.center,
    super.transformHitTests,
    super.filterQuality,
    super.child,
  })  : assert(
          !(scale == null && scaleX == null && scaleY == null),
          "At least one of 'scale', 'scaleX' and 'scaleY' is required to be "
          'non-null',
        ),
        assert(
          scale == null || (scaleX == null && scaleY == null),
          "If 'scale' is non-null then 'scaleX' and 'scaleY' must be left null",
        );

  final double? scale;
  final double? scaleX;
  final double? scaleY;

  Matrix4 _computeScale(double? scale, double? scaleX, double? scaleY) =>
      Matrix4.diagonal3Values(
        scale ?? scaleX ?? 1.0,
        scale ?? scaleY ?? 1.0,
        1,
      );

  @override
  Matrix4 get transform => _computeScale(scale, scaleX, scaleY);

  @override
  State<StatefulWidget> createState() => _ATransformScaleState();
}

class _ATransformScaleState extends _ATransformBaseState<_ATransformScale> {
  late final _scale = OptionalAnimatableDouble(widget.scale, state: this);
  late final _scaleX = OptionalAnimatableDouble(widget.scaleX, state: this);
  late final _scaleY = OptionalAnimatableDouble(widget.scaleY, state: this);

  @override
  bool get _useFilterQuality =>
      _scale.useFilterQuality ||
      _scaleX.useFilterQuality ||
      _scaleY.useFilterQuality;

  @override
  Matrix4 get _transform => widget._computeScale(
        _scale.animatedValue,
        _scaleX.animatedValue,
        _scaleY.animatedValue,
      );

  @override
  void updateAnimatableParameters() {
    super.updateAnimatableParameters();
    _scale.value = widget.scale;
    _scaleX.value = widget.scaleX;
    _scaleY.value = widget.scaleY;
  }
}
