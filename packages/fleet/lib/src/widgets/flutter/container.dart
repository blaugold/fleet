// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animatable_render_object_widget.dart';
import '../../animation/animatable_stateless_widget.dart';
import '../../animation/parameter.dart';

typedef _DecoratedBoxAnimatableParameters = ({
  AnimatableDecoration decoration,
});

/// Fleet's drop-in replacement of [DecoratedBox].
///
/// {@category Flutter drop-in replacement}
class FleetDecoratedBox extends DecoratedBox
    with
        AnimatableSingleChildRenderObjectWidgetMixin<
            _DecoratedBoxAnimatableParameters> {
  /// Corresponding constructor to [DecoratedBox].
  const FleetDecoratedBox({
    super.key,
    required super.decoration,
    super.position,
    super.child,
  });

  @override
  _DecoratedBoxAnimatableParameters createAnimatableParameters(
    covariant RenderObject renderObject,
    AnimatableParameterHost host,
  ) {
    return (decoration: AnimatableDecoration(decoration, host: host),);
  }

  @override
  void updateAnimatableParameters(
    BuildContext context,
    _DecoratedBoxAnimatableParameters parameters,
  ) {
    parameters.decoration.value = decoration;
  }

  @override
  void updateRenderObjectWithAnimatableParameters(
    BuildContext context,
    covariant RenderDecoratedBox renderObject,
    _DecoratedBoxAnimatableParameters parameters,
  ) {
    renderObject.decoration = parameters.decoration.animatedValue;
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

/// Fleet's drop-in replacement of [Container].
///
/// {@category Flutter drop-in replacement}
class FleetContainer
    extends AnimatableStatelessWidget<_ContainerAnimatableParameters> {
  /// Corresponding constructor to [Container].
  FleetContainer({
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
