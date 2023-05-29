// ignore_for_file: library_private_types_in_public_api

import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../animation/animatable_render_object_widget.dart';
import '../animation/animatable_stateless_widget.dart';
import '../animation/parameter.dart';

typedef _AlignAnimatableParameters = ({
  AnimatableAlignmentGeometry alignment,
  OptionalAnimatableDouble widthFactor,
  OptionalAnimatableDouble heightFactor,
});

/// Animatable version of [Align].
///
/// {@category Animatable Flutter widget}
class AAlign extends Align
    with
        AnimatableSingleChildRenderObjectWidgetMixin<
            _AlignAnimatableParameters> {
  /// Creates an animatable version of [Align].
  const AAlign({
    super.key,
    super.alignment,
    super.widthFactor,
    super.heightFactor,
    super.child,
  });

  @override
  _AlignAnimatableParameters createAnimatableParameters(
    covariant RenderPositionedBox renderObject,
    AnimatableParameterHost host,
  ) {
    return (
      alignment: AnimatableAlignmentGeometry(alignment, host: host),
      widthFactor: OptionalAnimatableDouble(widthFactor, host: host),
      heightFactor: OptionalAnimatableDouble(heightFactor, host: host),
    );
  }

  @override
  void updateAnimatableParameters(
    BuildContext context,
    _AlignAnimatableParameters parameters,
  ) {
    parameters
      ..alignment.value = alignment
      ..widthFactor.value = widthFactor
      ..heightFactor.value = heightFactor;
  }

  @override
  void updateRenderObjectWithAnimatableParameters(
    BuildContext context,
    covariant RenderPositionedBox renderObject,
    _AlignAnimatableParameters parameters,
  ) {
    final (:alignment, :widthFactor, :heightFactor) = parameters;
    renderObject
      ..alignment = alignment.animatedValue
      ..widthFactor = widthFactor.animatedValue
      ..heightFactor = heightFactor.animatedValue;
  }
}

/// Animatable version of [ColoredBox].
///
/// {@category Animatable Flutter widget}
class AColoredBox extends AnimatableStatelessWidget<AnimatableColor> {
  /// Creates an animatable version of [ColoredBox].
  const AColoredBox({super.key, required this.color, this.child});

  /// See [ColoredBox.color].
  final Color color;

  /// See [ProxyWidget.child].
  final Widget? child;

  @override
  AnimatableColor createAnimatableParameters(AnimatableParameterHost host) {
    return AnimatableColor(color, host: host);
  }

  @override
  void updateAnimatableParameters(AnimatableColor parameters) {
    parameters.value = color;
  }

  @override
  Widget build(BuildContext context, AnimatableColor? parameters) {
    return ColoredBox(
      color: parameters?.animatedValue ?? color,
      child: child,
    );
  }
}

typedef _ContainerAnimatableParameters = ({
  OptionalAnimatableAlignmentGeometry alignment,
  OptionalAnimatableEdgeInsetsGeometry padding,
  OptionalAnimatableColor color,
  OptionalAnimatableDecoration decoration,
  OptionalAnimatableDecoration foregroundDecoration,
  OptionalAnimatableBoxConstraints constraints,
  OptionalAnimatableEdgeInsetsGeometry margin,
  OptionalAnimatableMatrix4 transform,
  OptionalAnimatableAlignmentGeometry transformAlignment,
});

/// Animatable version of [Container].
///
/// {@category Animatable Flutter widget}
class AContainer
    extends AnimatableStatelessWidget<_ContainerAnimatableParameters> {
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
  _ContainerAnimatableParameters createAnimatableParameters(
    AnimatableParameterHost host,
  ) {
    return (
      alignment: OptionalAnimatableAlignmentGeometry(alignment, host: host),
      padding: OptionalAnimatableEdgeInsetsGeometry(padding, host: host),
      color: OptionalAnimatableColor(color, host: host),
      decoration: OptionalAnimatableDecoration(decoration, host: host),
      foregroundDecoration:
          OptionalAnimatableDecoration(foregroundDecoration, host: host),
      constraints: OptionalAnimatableBoxConstraints(constraints, host: host),
      margin: OptionalAnimatableEdgeInsetsGeometry(margin, host: host),
      transform: OptionalAnimatableMatrix4(transform, host: host),
      transformAlignment:
          OptionalAnimatableAlignmentGeometry(transformAlignment, host: host),
    );
  }

  @override
  void updateAnimatableParameters(_ContainerAnimatableParameters parameters) {
    parameters
      ..alignment.value = alignment
      ..padding.value = padding
      ..color.value = color
      ..decoration.value = decoration
      ..foregroundDecoration.value = foregroundDecoration
      ..constraints.value = constraints
      ..margin.value = margin
      ..transform.value = transform
      ..transformAlignment.value = transformAlignment;
  }

  @override
  Widget build(
    BuildContext context,
    _ContainerAnimatableParameters? parameters,
  ) {
    return Container(
      alignment: parameters?.alignment.animatedValue ?? alignment,
      padding: parameters?.padding.animatedValue ?? padding,
      color: parameters?.color.animatedValue ?? color,
      decoration: parameters?.decoration.animatedValue ?? decoration,
      foregroundDecoration: parameters?.foregroundDecoration.animatedValue ??
          foregroundDecoration,
      constraints: parameters?.constraints.animatedValue ?? constraints,
      margin: parameters?.margin.animatedValue ?? margin,
      transform: parameters?.transform.animatedValue ?? transform,
      transformAlignment:
          parameters?.transformAlignment.animatedValue ?? transformAlignment,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}

typedef _OpacityAnimatableParameters = ({AnimatableDouble opacity});

/// Animatable version of [Opacity].
///
/// {@category Animatable Flutter widget}
class AOpacity extends Opacity
    with
        AnimatableSingleChildRenderObjectWidgetMixin<
            _OpacityAnimatableParameters> {
  /// Creates an animatable version of [Opacity].
  const AOpacity({
    super.key,
    required super.opacity,
    super.alwaysIncludeSemantics,
    super.child,
  });

  @override
  _OpacityAnimatableParameters createAnimatableParameters(
    covariant RenderOpacity renderObject,
    AnimatableParameterHost host,
  ) {
    return (opacity: AnimatableDouble(opacity, host: host));
  }

  @override
  void updateAnimatableParameters(
    BuildContext context,
    _OpacityAnimatableParameters parameters,
  ) {
    parameters.opacity.value = opacity;
  }

  @override
  void updateRenderObjectWithAnimatableParameters(
    BuildContext context,
    covariant RenderOpacity renderObject,
    _OpacityAnimatableParameters parameters,
  ) {
    final (:opacity) = parameters;
    renderObject.opacity = opacity.animatedValue;
  }
}

typedef _PaddingAnimatableParameters = ({AnimatableEdgeInsetsGeometry padding});

/// Animatable version of [Padding].
///
/// {@category Animatable Flutter widget}
class APadding extends Padding
    with
        AnimatableSingleChildRenderObjectWidgetMixin<
            _PaddingAnimatableParameters> {
  /// Creates an animatable version of [Padding].
  const APadding({super.key, required super.padding, super.child});

  @override
  _PaddingAnimatableParameters createAnimatableParameters(
    covariant RenderPadding renderObject,
    AnimatableParameterHost host,
  ) {
    return (padding: AnimatableEdgeInsetsGeometry(padding, host: host),);
  }

  @override
  void updateAnimatableParameters(
    BuildContext context,
    _PaddingAnimatableParameters parameters,
  ) {
    parameters.padding.value = padding;
  }

  @override
  void updateRenderObjectWithAnimatableParameters(
    BuildContext context,
    covariant RenderPadding renderObject,
    _PaddingAnimatableParameters parameters,
  ) {
    final (:padding) = parameters;
    renderObject.padding = padding.animatedValue;
  }
}

typedef _PositionedAnimatableParameters = ({
  OptionalAnimatableDouble left,
  OptionalAnimatableDouble top,
  OptionalAnimatableDouble right,
  OptionalAnimatableDouble bottom,
  OptionalAnimatableDouble width,
  OptionalAnimatableDouble height,
});

/// Animatable version of [Positioned].
///
/// {@category Animatable Flutter widget}
class APositioned
    extends AnimatableStatelessWidget<_PositionedAnimatableParameters> {
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
  _PositionedAnimatableParameters createAnimatableParameters(
    AnimatableParameterHost host,
  ) {
    return (
      left: OptionalAnimatableDouble(left, host: host),
      top: OptionalAnimatableDouble(top, host: host),
      right: OptionalAnimatableDouble(right, host: host),
      bottom: OptionalAnimatableDouble(bottom, host: host),
      width: OptionalAnimatableDouble(width, host: host),
      height: OptionalAnimatableDouble(height, host: host),
    );
  }

  @override
  void updateAnimatableParameters(_PositionedAnimatableParameters parameters) {
    parameters
      ..left.value = left
      ..top.value = top
      ..right.value = right
      ..bottom.value = bottom
      ..width.value = width
      ..height.value = height;
  }

  @override
  Widget build(
    BuildContext context,
    _PositionedAnimatableParameters? parameters,
  ) {
    return Positioned(
      left: parameters?.left.animatedValue ?? left,
      top: parameters?.top.animatedValue ?? top,
      right: parameters?.right.animatedValue ?? right,
      bottom: parameters?.bottom.animatedValue ?? bottom,
      width: parameters?.width.animatedValue ?? width,
      height: parameters?.height.animatedValue ?? height,
      child: child,
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

typedef _SizedBoxAnimatableParameters = ({
  AnimatableBoxConstraints additionalConstraints
});

/// Animatable version of [SizedBox].
///
/// {@category Animatable Flutter widget}
class ASizedBox extends SizedBox
    with
        AnimatableSingleChildRenderObjectWidgetMixin<
            _SizedBoxAnimatableParameters> {
  /// Creates an animatable version of [SizedBox].
  const ASizedBox({
    super.key,
    super.height,
    super.width,
    super.child,
  });

  /// See [SizedBox.fromSize].
  ASizedBox.fromSize({super.key, super.child, super.size}) : super.fromSize();

  /// See [SizedBox.square].
  const ASizedBox.square({super.key, super.child, super.dimension})
      : super.square();

  BoxConstraints get _additionalConstraints {
    return BoxConstraints.tightFor(width: width, height: height);
  }

  @override
  _SizedBoxAnimatableParameters createAnimatableParameters(
    covariant RenderConstrainedBox renderObject,
    AnimatableParameterHost host,
  ) {
    return (
      additionalConstraints: AnimatableBoxConstraints(
        _additionalConstraints,
        host: host,
      ),
    );
  }

  @override
  void updateAnimatableParameters(
    BuildContext context,
    _SizedBoxAnimatableParameters parameters,
  ) {
    parameters.additionalConstraints.value = _additionalConstraints;
  }

  @override
  void updateRenderObjectWithAnimatableParameters(
    BuildContext context,
    covariant RenderConstrainedBox renderObject,
    _SizedBoxAnimatableParameters parameters,
  ) {
    final (:additionalConstraints) = parameters;
    renderObject.additionalConstraints = additionalConstraints.animatedValue;
  }
}

typedef _SliverOpacityAnimatableParameters = ({AnimatableDouble opacity});

/// Animatable version of [SliverOpacity].
///
/// {@category Animatable Flutter widget}
class ASliverOpacity extends SliverOpacity
    with
        AnimatableSingleChildRenderObjectWidgetMixin<
            _SliverOpacityAnimatableParameters> {
  /// Creates an animatable version of [SliverOpacity].
  const ASliverOpacity({
    super.key,
    required super.opacity,
    super.alwaysIncludeSemantics,
    super.sliver,
  });

  @override
  _SliverOpacityAnimatableParameters createAnimatableParameters(
    covariant RenderSliverOpacity renderObject,
    AnimatableParameterHost host,
  ) {
    return (opacity: AnimatableDouble(opacity, host: host),);
  }

  @override
  void updateAnimatableParameters(
    BuildContext context,
    _SliverOpacityAnimatableParameters parameters,
  ) {
    parameters.opacity.value = opacity;
  }

  @override
  void updateRenderObjectWithAnimatableParameters(
    BuildContext context,
    covariant RenderSliverOpacity renderObject,
    _SliverOpacityAnimatableParameters parameters,
  ) {
    final (:opacity) = parameters;
    renderObject.opacity = opacity.animatedValue;
  }
}

typedef _SliverPaddingAnimatableParameters = ({
  AnimatableEdgeInsetsGeometry padding
});

/// Animatable version of [SliverPadding].
///
/// {@category Animatable Flutter widget}
class ASliverPadding extends SliverPadding
    with
        AnimatableSingleChildRenderObjectWidgetMixin<
            _SliverPaddingAnimatableParameters> {
  /// Creates an animatable version of [SliverPadding].
  const ASliverPadding({super.key, required super.padding, super.sliver});

  @override
  _SliverPaddingAnimatableParameters createAnimatableParameters(
    covariant RenderSliverPadding renderObject,
    AnimatableParameterHost host,
  ) {
    return (padding: AnimatableEdgeInsetsGeometry(padding, host: host),);
  }

  @override
  void updateAnimatableParameters(
    BuildContext context,
    _SliverPaddingAnimatableParameters parameters,
  ) {
    parameters.padding.value = padding;
  }

  @override
  void updateRenderObjectWithAnimatableParameters(
    BuildContext context,
    covariant RenderSliverPadding renderObject,
    _SliverPaddingAnimatableParameters parameters,
  ) {
    final (:padding) = parameters;
    renderObject.padding = padding.animatedValue;
  }
}

/// Animatable version of [Transform].
///
/// {@category Animatable Flutter widget}
abstract class ATransform extends Transform {
  /// Creates an animatable version of [Transform].
  const factory ATransform({
    Key? key,
    required Matrix4 transform,
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests,
    FilterQuality? filterQuality,
    Widget? child,
  }) = _MatrixTransform;

  /// Creates an animatable version of [Transform.rotate].
  factory ATransform.rotate({
    Key? key,
    required double angle,
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests,
    FilterQuality? filterQuality,
    Widget? child,
  }) = _RotateTransform;

  /// Creates an animatable version of [Transform.translate].
  factory ATransform.translate({
    Key? key,
    required Offset offset,
    bool transformHitTests,
    FilterQuality? filterQuality,
    Widget? child,
  }) = _TranslateTransform;

  /// Creates an animatable version of [Transform.scale].
  factory ATransform.scale({
    Key? key,
    double? scale,
    double? scaleX,
    double? scaleY,
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests,
    FilterQuality? filterQuality,
    Widget? child,
  }) = _ScaleTransform;

  const ATransform._({
    super.key,
    required super.transform,
    super.origin,
    super.alignment,
    super.transformHitTests,
    super.filterQuality,
    super.child,
  }) : super();
}

typedef _TransformAnimatableParameters<T> = ({
  T transformInput,
  OptionalAnimatableObject<Offset> origin,
  OptionalAnimatableAlignmentGeometry alignment,
});

/// Animatable version of [Transform].
///
/// {@category Animatable Flutter widget}
abstract class _TransformBase<T> extends ATransform
    with
        AnimatableSingleChildRenderObjectWidgetMixin<
            _TransformAnimatableParameters<T>> {
  const _TransformBase._({
    super.key,
    required super.transform,
    super.origin,
    super.alignment,
    super.transformHitTests,
    super.filterQuality,
    super.child,
  }) : super._();

  T createTransformInputParameters(AnimatableParameterHost host);

  void updateTransformInputParameters(T parameters);

  Matrix4 buildTransform(T parameters);

  bool useFilterQuality(T parameters);

  @override
  _TransformAnimatableParameters<T> createAnimatableParameters(
    covariant RenderTransform renderObject,
    AnimatableParameterHost host,
  ) {
    return (
      transformInput: createTransformInputParameters(host),
      origin: OptionalAnimatableObject(origin, host: host),
      alignment: OptionalAnimatableAlignmentGeometry(alignment, host: host),
    );
  }

  @override
  void updateAnimatableParameters(
    BuildContext context,
    _TransformAnimatableParameters<T> parameters,
  ) {
    updateTransformInputParameters(parameters.transformInput);
    parameters.origin.value = origin;
    parameters.alignment.value = alignment;
  }

  @override
  void updateRenderObjectWithAnimatableParameters(
    BuildContext context,
    covariant RenderTransform renderObject,
    _TransformAnimatableParameters<T> parameters,
  ) {
    final (:transformInput, :origin, :alignment) = parameters;
    renderObject.transform = buildTransform(transformInput);
    renderObject.origin = origin.animatedValue;
    renderObject.alignment = alignment.animatedValue;
    renderObject.filterQuality =
        useFilterQuality(transformInput) ? filterQuality : null;
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

class _MatrixTransform extends _TransformBase<AnimatableMatrix4> {
  const _MatrixTransform({
    super.key,
    required super.transform,
    super.origin,
    super.alignment,
    super.transformHitTests,
    super.filterQuality,
    super.child,
  }) : super._();

  @override
  AnimatableMatrix4 createTransformInputParameters(
    AnimatableParameterHost host,
  ) {
    return AnimatableMatrix4(transform, host: host);
  }

  @override
  void updateTransformInputParameters(AnimatableMatrix4 parameters) {
    parameters.value = transform;
  }

  @override
  Matrix4 buildTransform(AnimatableMatrix4 parameters) {
    return parameters.animatedValue;
  }

  @override
  bool useFilterQuality(AnimatableMatrix4 parameters) {
    return parameters.useFilterQuality;
  }
}

class _RotateTransform extends _TransformBase<AnimatableDouble> {
  _RotateTransform({
    super.key,
    required this.angle,
    super.origin,
    super.alignment,
    super.transformHitTests,
    super.filterQuality,
    super.child,
  }) : super._(transform: _computeRotation(angle));

  final double angle;

  @override
  AnimatableDouble createTransformInputParameters(
    AnimatableParameterHost host,
  ) {
    return AnimatableDouble(angle, host: host);
  }

  @override
  void updateTransformInputParameters(AnimatableDouble parameters) {
    parameters.value = angle;
  }

  @override
  Matrix4 buildTransform(AnimatableDouble parameters) {
    return _computeRotation(parameters.animatedValue);
  }

  @override
  bool useFilterQuality(AnimatableDouble parameters) {
    return parameters.useFilterQuality;
  }

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

class _TranslateTransform extends _TransformBase<AnimatableObject<Offset>> {
  _TranslateTransform({
    super.key,
    required this.offset,
    super.transformHitTests,
    super.filterQuality,
    super.child,
  }) : super._(transform: Matrix4.translationValues(offset.dx, offset.dy, 0));

  final Offset offset;

  @override
  AnimatableObject<Offset> createTransformInputParameters(
    AnimatableParameterHost host,
  ) {
    return AnimatableObject(offset, host: host);
  }

  @override
  void updateTransformInputParameters(AnimatableObject<Offset> parameters) {
    parameters.value = offset;
  }

  @override
  Matrix4 buildTransform(AnimatableObject<Offset> parameters) {
    final offset = parameters.animatedValue;
    return Matrix4.translationValues(offset.dx, offset.dy, 0);
  }

  @override
  bool useFilterQuality(AnimatableObject<Offset> parameters) {
    return parameters.useFilterQuality;
  }
}

typedef _ScaleTransformAnimatableParameters = ({
  OptionalAnimatableDouble scale,
  OptionalAnimatableDouble scaleX,
  OptionalAnimatableDouble scaleY,
});

class _ScaleTransform
    extends _TransformBase<_ScaleTransformAnimatableParameters> {
  _ScaleTransform({
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
        ),
        super._(transform: _computeScale(scale, scaleX, scaleY));

  final double? scale;
  final double? scaleX;
  final double? scaleY;

  static Matrix4 _computeScale(double? scale, double? scaleX, double? scaleY) =>
      Matrix4.diagonal3Values(
        scale ?? scaleX ?? 1.0,
        scale ?? scaleY ?? 1.0,
        1,
      );

  @override
  _ScaleTransformAnimatableParameters createTransformInputParameters(
    AnimatableParameterHost host,
  ) {
    return (
      scale: OptionalAnimatableDouble(scale, host: host),
      scaleX: OptionalAnimatableDouble(scaleX, host: host),
      scaleY: OptionalAnimatableDouble(scaleY, host: host),
    );
  }

  @override
  void updateTransformInputParameters(
    _ScaleTransformAnimatableParameters parameters,
  ) {
    parameters
      ..scale.value = scale
      ..scaleX.value = scaleX
      ..scaleY.value = scaleY;
  }

  @override
  Matrix4 buildTransform(_ScaleTransformAnimatableParameters parameters) {
    final (:scale, :scaleX, :scaleY) = parameters;
    return _computeScale(
      scale.animatedValue,
      scaleX.animatedValue,
      scaleY.animatedValue,
    );
  }

  @override
  bool useFilterQuality(_ScaleTransformAnimatableParameters parameters) {
    final (:scale, :scaleX, :scaleY) = parameters;
    return scale.useFilterQuality ||
        scaleX.useFilterQuality ||
        scaleY.useFilterQuality;
  }
}
