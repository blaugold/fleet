// ignore_for_file: library_private_types_in_public_api

import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animatable_render_object_widget.dart';
import '../../animation/animatable_stateless_widget.dart';
import '../../animation/parameter.dart';
import '../../environment.dart';
import '../opinionated_defaults.dart';

typedef _AlignAnimatableParameters = ({
  AnimatableAlignmentGeometry alignment,
  OptionalAnimatableDouble widthFactor,
  OptionalAnimatableDouble heightFactor,
});

/// Fleet's drop-in replacement of [Align].
///
/// {@category Flutter drop-in replacement}
class FleetAlign extends Align
    with
        AnimatableSingleChildRenderObjectWidgetMixin<
            _AlignAnimatableParameters> {
  /// Corresponds constructor to [Align].
  const FleetAlign({
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

/// Fleet's drop-in replacement of [Center].
///
/// {@category Flutter drop-in replacement}
class FleetCenter extends FleetAlign {
  /// Corresponds constructor to [Center].
  const FleetCenter({
    super.key,
    super.widthFactor,
    super.heightFactor,
    super.child,
  });
}

/// Fleet's drop-in replacement of [ColoredBox].
///
/// {@category Flutter drop-in replacement}
class FleetColoredBox extends AnimatableStatelessWidget<AnimatableColor> {
  /// Corresponding constructor to [ColoredBox].
  const FleetColoredBox({super.key, required this.color, this.child});

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

typedef _OpacityAnimatableParameters = ({AnimatableDouble opacity});

/// Fleet's drop-in replacement of [Opacity].
///
/// {@category Flutter drop-in replacement}
class FleetOpacity extends Opacity
    with
        AnimatableSingleChildRenderObjectWidgetMixin<
            _OpacityAnimatableParameters> {
  /// Corresponding constructor to [Opacity].
  const FleetOpacity({
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

typedef _FractionalTranslationAnimatableParameters = ({
  AnimatableParameter<Offset> translation,
});

/// Fleet's drop-in replacement of [FractionalTranslation].
///
/// {@category Flutter drop-in replacement}
class FleetFractionalTranslation extends FractionalTranslation
    with
        AnimatableSingleChildRenderObjectWidgetMixin<
            _FractionalTranslationAnimatableParameters> {
  /// Corresponding constructor to [FractionalTranslation].
  const FleetFractionalTranslation({
    super.key,
    required super.translation,
    super.transformHitTests = true,
    super.child,
  });

  @override
  _FractionalTranslationAnimatableParameters createAnimatableParameters(
    covariant RenderObject renderObject,
    AnimatableParameterHost host,
  ) {
    return (translation: AnimatableObject(translation, host: host),);
  }

  @override
  void updateAnimatableParameters(
    BuildContext context,
    _FractionalTranslationAnimatableParameters parameters,
  ) {
    parameters.translation.value = translation;
  }

  @override
  void updateRenderObjectWithAnimatableParameters(
    BuildContext context,
    covariant RenderFractionalTranslation renderObject,
    _FractionalTranslationAnimatableParameters parameters,
  ) {
    renderObject.translation = parameters.translation.animatedValue;
  }
}

typedef _PaddingAnimatableParameters = ({AnimatableEdgeInsetsGeometry padding});

/// Fleet's drop-in replacement of [Padding].
///
/// {@category Flutter drop-in replacement}
class FleetPadding extends Padding
    with
        AnimatableSingleChildRenderObjectWidgetMixin<
            _PaddingAnimatableParameters> {
  /// Corresponding constructor to [Padding].
  const FleetPadding({super.key, required super.padding, super.child});

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

/// Fleet's drop-in replacement of [Positioned].
///
/// {@category Flutter drop-in replacement}
class FleetPositioned
    extends AnimatableStatelessWidget<_PositionedAnimatableParameters> {
  /// Corresponding constructor to [Positioned].
  const FleetPositioned({
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

  /// Corresponding constructor to [Positioned.fromRect].
  FleetPositioned.fromRect({
    super.key,
    required Rect rect,
    required this.child,
  })  : left = rect.left,
        top = rect.top,
        width = rect.width,
        height = rect.height,
        right = null,
        bottom = null;

  /// Corresponding constructor to [Positioned.fromRelativeRect].
  FleetPositioned.fromRelativeRect({
    super.key,
    required RelativeRect rect,
    required this.child,
  })  : left = rect.left,
        top = rect.top,
        right = rect.right,
        bottom = rect.bottom,
        width = null,
        height = null;

  /// Corresponding constructor to [Positioned.fill].
  const FleetPositioned.fill({
    super.key,
    this.left = 0.0,
    this.top = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
    required this.child,
  })  : width = null,
        height = null;

  /// Corresponding constructor to [Positioned.directional].
  factory FleetPositioned.directional({
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
    return FleetPositioned(
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

/// Fleet's drop-in replacement of [PositionedDirectional].
///
/// {@category Flutter drop-in replacement}
class FleetPositionedDirectional extends StatelessWidget {
  /// Corresponding constructor to [PositionedDirectional].
  const FleetPositionedDirectional({
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
    return FleetPositioned.directional(
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

/// Fleet's drop-in replacement of [SizedBox].
///
/// {@category Flutter drop-in replacement}
class FleetSizedBox extends SizedBox
    with
        AnimatableSingleChildRenderObjectWidgetMixin<
            _SizedBoxAnimatableParameters> {
  /// Corresponding constructor to [SizedBox].
  const FleetSizedBox({
    super.key,
    super.height,
    super.width,
    super.child,
  });

  /// Corresponding constructor to [SizedBox.expand].
  FleetSizedBox.expand({super.key, super.child});

  /// Corresponding constructor to [SizedBox.shrink].
  FleetSizedBox.shrink({super.key, super.child});

  /// Corresponding constructor to [SizedBox.fromSize].
  FleetSizedBox.fromSize({super.key, super.child, super.size})
      : super.fromSize();

  /// Corresponding constructor to [SizedBox.square].
  const FleetSizedBox.square({super.key, super.child, super.dimension})
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

/// Fleet's drop-in replacement of [SliverOpacity].
///
/// {@category Flutter drop-in replacement}
class FleetSliverOpacity extends SliverOpacity
    with
        AnimatableSingleChildRenderObjectWidgetMixin<
            _SliverOpacityAnimatableParameters> {
  /// Corresponding constructor to [SliverOpacity].
  const FleetSliverOpacity({
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

/// Fleet's drop-in replacement of [SliverPadding].
///
/// {@category Flutter drop-in replacement}
class FleetSliverPadding extends SliverPadding
    with
        AnimatableSingleChildRenderObjectWidgetMixin<
            _SliverPaddingAnimatableParameters> {
  /// Corresponding constructor to [SliverPadding].
  const FleetSliverPadding({super.key, required super.padding, super.sliver});

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

/// Fleet's drop-in replacement of [Transform].
///
/// {@category Flutter drop-in replacement}
abstract class FleetTransform extends Transform {
  /// Corresponding constructor to [Transform].
  const factory FleetTransform({
    Key? key,
    required Matrix4 transform,
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests,
    FilterQuality? filterQuality,
    Widget? child,
  }) = _MatrixTransform;

  /// Corresponding constructor to [Transform.rotate].
  factory FleetTransform.rotate({
    Key? key,
    required double angle,
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests,
    FilterQuality? filterQuality,
    Widget? child,
  }) = _RotateTransform;

  /// Corresponding constructor to [Transform.translate].
  factory FleetTransform.translate({
    Key? key,
    required Offset offset,
    bool transformHitTests,
    FilterQuality? filterQuality,
    Widget? child,
  }) = _TranslateTransform;

  /// Corresponding constructor to [Transform.scale].
  factory FleetTransform.scale({
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

  const FleetTransform._({
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

abstract class _TransformBase<T> extends FleetTransform
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

final class _DefaultHorizontalMainAxisSize
    extends EnvironmentKey<MainAxisSize, _DefaultHorizontalMainAxisSize> {
  const _DefaultHorizontalMainAxisSize();

  @override
  MainAxisSize defaultValue(BuildContext context) => MainAxisSize.max;
}

/// [EnvironmentKey] for the default value for [FleetFlex.mainAxisSize] that is
/// used when no [MainAxisSize] is explicitly specified.
///
/// The default value is [MainAxisSize.max].
///
/// See also:
///
/// - [OpinionatedDefaults], which overrides this default.
const defaultHorizontalMainAxisSize = _DefaultHorizontalMainAxisSize();

final class _DefaultVerticalMainAxisSize
    extends EnvironmentKey<MainAxisSize, _DefaultHorizontalMainAxisSize> {
  const _DefaultVerticalMainAxisSize();

  @override
  MainAxisSize defaultValue(BuildContext context) => MainAxisSize.max;
}

/// [EnvironmentKey] for the default value for [FleetFlex.mainAxisSize] that is
/// used when no [MainAxisSize] is explicitly specified.
///
/// The default value is [MainAxisSize.max].
///
/// See also:
///
/// - [OpinionatedDefaults], which overrides this default.
const defaultVerticalMainAxisSize = _DefaultVerticalMainAxisSize();

/// Extension-based widget modifiers for [FleetFlex] specific features.
extension FleetFlexModifiers on Widget {
  /// Overrides the default value for [FleetFlex.mainAxisSize] that is used when
  /// no [MainAxisSize] is explicitly specified, for this widget and its
  /// descendants.
  @widgetFactory
  Widget defaultHorizontalMainAxisSize(MainAxisSize value) =>
      const _DefaultHorizontalMainAxisSize().update(value: value, child: this);

  /// Overrides the default value for [FleetFlex.mainAxisSize] that is used when
  /// no [MainAxisSize] is explicitly specified, for this widget and its
  /// descendants.
  @widgetFactory
  Widget defaultVerticalMainAxisSize(MainAxisSize value) =>
      const _DefaultVerticalMainAxisSize().update(value: value, child: this);
}

/// Fleet's drop-in replacement of [Flex].
///
/// {@category Flutter drop-in replacement}
class FleetFlex extends StatelessWidget {
  /// Corresponding constructor to [Flex].
  const FleetFlex({
    super.key,
    required this.direction,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.clipBehavior = Clip.none,
    this.spacing,
    this.children = const <Widget>[],
  }) : assert(
          !identical(crossAxisAlignment, CrossAxisAlignment.baseline) ||
              textBaseline != null,
          'textBaseline is required if you specify the crossAxisAlignment with '
          'CrossAxisAlignment.baseline',
        );

  /// See [Flex.direction].
  final Axis direction;

  /// See [Flex.mainAxisAlignment].
  final MainAxisAlignment mainAxisAlignment;

  /// See [Flex.mainAxisSize].
  final MainAxisSize? mainAxisSize;

  /// See [Flex.crossAxisAlignment].
  final CrossAxisAlignment crossAxisAlignment;

  /// See [Flex.textDirection].
  final TextDirection? textDirection;

  /// See [Flex.verticalDirection].
  final VerticalDirection verticalDirection;

  /// See [Flex.textBaseline].
  final TextBaseline? textBaseline;

  /// See [Flex.clipBehavior].
  final Clip clipBehavior;

  /// The amount of space to place between children in a run in the main axis.
  ///
  /// If this is null, no spacing is added.
  final double? spacing;

  /// See [Flex.children].
  final List<Widget> children;

  bool get _needTextDirection {
    switch (direction) {
      case Axis.horizontal:
        return true; // because it affects the layout order.
      case Axis.vertical:
        return crossAxisAlignment == CrossAxisAlignment.start ||
            crossAxisAlignment == CrossAxisAlignment.end;
    }
  }

  /// See [Flex.getEffectiveTextDirection].
  @protected
  TextDirection? getEffectiveTextDirection(BuildContext context) {
    return textDirection ??
        (_needTextDirection ? Directionality.maybeOf(context) : null);
  }

  @protected
  MainAxisSize _getEffectiveMainAxisSize(BuildContext context) {
    return mainAxisSize ??
        switch (direction) {
          Axis.horizontal => defaultHorizontalMainAxisSize.of(context),
          Axis.vertical => defaultVerticalMainAxisSize.of(context),
        };
  }

  @override
  Widget build(BuildContext context) {
    final spacing = this.spacing;
    var children = this.children;

    if (spacing != null) {
      final spacer = FleetSizedBox(
        width: direction == Axis.horizontal ? spacing : null,
        height: direction == Axis.vertical ? spacing : null,
      );
      children = [
        for (final child in children) ...[
          child,
          if (child != children.last) spacer
        ],
      ];
    }

    return Flex(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: _getEffectiveMainAxisSize(context),
      crossAxisAlignment: crossAxisAlignment,
      textDirection: getEffectiveTextDirection(context),
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      children: children,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<Axis>('direction', direction));
    properties.add(
      EnumProperty<MainAxisAlignment>(
        'mainAxisAlignment',
        mainAxisAlignment,
      ),
    );
    properties.add(
      EnumProperty<MainAxisSize>(
        'mainAxisSize',
        mainAxisSize,
        defaultValue: MainAxisSize.max,
      ),
    );
    properties.add(
      EnumProperty<CrossAxisAlignment>(
        'crossAxisAlignment',
        crossAxisAlignment,
      ),
    );
    properties.add(
      EnumProperty<TextDirection>(
        'textDirection',
        textDirection,
        defaultValue: null,
      ),
    );
    properties.add(
      EnumProperty<VerticalDirection>(
        'verticalDirection',
        verticalDirection,
        defaultValue: VerticalDirection.down,
      ),
    );
    properties.add(
      EnumProperty<TextBaseline>(
        'textBaseline',
        textBaseline,
        defaultValue: null,
      ),
    );
  }
}

/// Extension to provide children of [FleetFlex] through partial-application.
extension FleetFlexApplyChildren on FleetFlex {
  /// Returns a new [FleetFlex] with the given [children].
  @widgetFactory
  FleetFlex call(List<Widget> children) {
    return FleetFlex(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      spacing: spacing,
      children: children,
    );
  }
}

/// Fleet's drop-in replacement of [Row].
///
/// {@category Flutter drop-in replacement}
class FleetRow extends FleetFlex {
  /// Corresponding constructor to [Row].
  const FleetRow({
    super.key,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    super.clipBehavior,
    super.spacing,
    super.children,
  }) : super(direction: Axis.horizontal);
}

/// Extension to provide children of [FleetRow] through partial-application.
extension FleetRowApplyChildren on FleetRow {
  /// Returns a new [FleetRow] with the given [children].
  @widgetFactory
  FleetRow call(List<Widget> children) {
    return FleetRow(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      spacing: spacing,
      children: children,
    );
  }
}

/// Fleet's drop-in replacement of [Column].
///
/// {@category Flutter drop-in replacement}
class FleetColumn extends FleetFlex {
  /// Corresponding constructor to [Column].
  const FleetColumn({
    super.key,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    super.clipBehavior,
    super.spacing,
    super.children,
  }) : super(direction: Axis.vertical);
}

/// Extension to provide children of [FleetColumn] through partial-application.
extension FleetColumnApplyChildren on FleetColumn {
  /// Returns a new [FleetColumn] with the given [children].
  @widgetFactory
  FleetColumn call(List<Widget> children) {
    return FleetColumn(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      spacing: spacing,
      children: children,
    );
  }
}

/// Extension to provide children of [Stack] through partial-application.
extension FleetStackApplyChildren on Stack {
  /// Returns a new [Stack] with the given [children].
  @widgetFactory
  Stack call(List<Widget> children) {
    return Stack(
      alignment: alignment,
      textDirection: textDirection,
      fit: fit,
      clipBehavior: clipBehavior,
      children: children,
    );
  }
}

/// Extension to provide children of [IndexedStack] through partial-application.
extension FleetIndexedStackApplyChildren on IndexedStack {
  /// Returns a new [IndexedStack] with the given [children].
  @widgetFactory
  IndexedStack call(List<Widget> children) {
    return IndexedStack(
      alignment: alignment,
      textDirection: textDirection,
      clipBehavior: clipBehavior,
      sizing: sizing,
      index: index,
      children: children,
    );
  }
}

/// Extension to provide children of [Wrap] through partial-application.
extension FleetWrapApplyChildren on Wrap {
  /// Returns a new [Wrap] with the given [children].
  @widgetFactory
  Wrap call(List<Widget> children) {
    return Wrap(
      direction: direction,
      alignment: alignment,
      spacing: spacing,
      runAlignment: runAlignment,
      runSpacing: runSpacing,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      clipBehavior: clipBehavior,
      children: children,
    );
  }
}

typedef _AspectRatioAnimatableParameters = ({
  AnimatableDouble aspectRatio,
});

/// Fleet's drop-in replacement of [AspectRatio].
class FleetAspectRatio extends AspectRatio
    with
        AnimatableSingleChildRenderObjectWidgetMixin<
            _AspectRatioAnimatableParameters> {
  /// Corresponding constructor to [AspectRatio].
  const FleetAspectRatio({
    super.key,
    required super.aspectRatio,
    super.child,
  });

  @override
  _AspectRatioAnimatableParameters createAnimatableParameters(
    covariant RenderAspectRatio renderObject,
    AnimatableParameterHost host,
  ) {
    return (aspectRatio: AnimatableDouble(aspectRatio, host: host));
  }

  @override
  void updateAnimatableParameters(
    BuildContext context,
    _AspectRatioAnimatableParameters parameters,
  ) {
    parameters.aspectRatio.value = aspectRatio;
  }

  @override
  void updateRenderObjectWithAnimatableParameters(
    BuildContext context,
    covariant RenderAspectRatio renderObject,
    _AspectRatioAnimatableParameters parameters,
  ) {
    renderObject.aspectRatio = parameters.aspectRatio.animatedValue;
  }
}
