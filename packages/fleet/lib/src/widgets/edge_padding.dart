// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../animatable_render_object_widget.dart';
import '../parameter.dart';

enum Edge {
  start,
  end,
  top,
  bottom;

  static const all = {top, bottom, start, end};
  static const vertical = {top, bottom};
  static const horizontal = {start, end};
  static const onlyStart = {start};
  static const onlyEnd = {end};
  static const onlyTop = {top};
  static const onlyBottom = {bottom};
}

extension on Set<Edge> {
  EdgeInsetsGeometry toEdgeInsets(double length) {
    return EdgeInsetsDirectional.only(
      top: contains(Edge.top) ? length : 0,
      bottom: contains(Edge.bottom) ? length : 0,
      start: contains(Edge.start) ? length : 0,
      end: contains(Edge.end) ? length : 0,
    );
  }
}

class DefaultPadding extends InheritedWidget {
  const DefaultPadding({
    super.key,
    required this.amount,
    required super.child,
  });

  // TODO: Maybe make this platform specific?
  static const _defaultAmount = 8.0;

  static double of(BuildContext context) {
    final amount =
        context.dependOnInheritedWidgetOfExactType<DefaultPadding>()?.amount;
    return amount ?? _defaultAmount;
  }

  final double amount;

  @override
  bool updateShouldNotify(covariant DefaultPadding oldWidget) =>
      amount != oldWidget.amount;
}

typedef _PaddingAnimatableParameters = ({AnimatableEdgeInsetsGeometry padding});

class EdgePadding extends SingleChildRenderObjectWidget
    with
        AnimatableSingleChildRenderObjectWidgetMixin<
            _PaddingAnimatableParameters> {
  const EdgePadding({
    super.key,
    required this.edges,
    required this.amount,
    super.child,
  });

  final Set<Edge> edges;
  final double? amount;

  EdgeInsetsGeometry _resolvePadding(BuildContext context) {
    return edges.toEdgeInsets(amount ?? DefaultPadding.of(context));
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderPadding(
      padding: _resolvePadding(context),
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderPadding renderObject,
  ) {
    renderObject
      ..padding = _resolvePadding(context)
      ..textDirection = Directionality.of(context);
  }

  @override
  _PaddingAnimatableParameters createAnimatableParameters(
    covariant RenderPadding renderObject,
    AnimatableParameterHost host,
  ) {
    return (
      padding: AnimatableEdgeInsetsGeometry(
        renderObject.padding,
        host: host,
      )
    );
  }

  @override
  void updateAnimatableParameters(
    BuildContext context,
    _PaddingAnimatableParameters parameters,
  ) {
    parameters.padding.value = _resolvePadding(context);
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
