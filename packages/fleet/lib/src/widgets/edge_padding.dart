// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../animatable_render_object_widget.dart';
import '../parameter.dart';

/// An edge of a rectangle.
enum Edge {
  /// The beginning edge in the reading direction.
  start,

  /// The ending edge in the reading direction.
  end,

  /// The top edge.
  top,

  /// The bottom edge.
  bottom;

  /// Set of all edges.
  static const all = {top, bottom, start, end};

  /// Set of all edges along the vertical axis.
  static const vertical = {top, bottom};

  /// Set of all edges along the horizontal axis.
  static const horizontal = {start, end};

  /// Set that contains only the [start] edge.
  static const onlyStart = {start};

  /// Set that contains only the [end] edge.
  static const onlyEnd = {end};

  /// Set that contains only the [top] edge.
  static const onlyTop = {top};

  /// Set that contains only the [bottom] edge.
  static const onlyBottom = {bottom};
}

extension on Set<Edge> {
  EdgeInsetsGeometry toEdgeInsets(double amount) {
    return EdgeInsetsDirectional.only(
      top: contains(Edge.top) ? amount : 0,
      bottom: contains(Edge.bottom) ? amount : 0,
      start: contains(Edge.start) ? amount : 0,
      end: contains(Edge.end) ? amount : 0,
    );
  }
}

/// Widget that provides a default amount of padding to use in [EdgePadding]s
/// below it.
class DefaultPadding extends InheritedWidget {
  /// Creates a [DefaultPadding] widget.
  const DefaultPadding({
    super.key,
    required this.amount,
    required super.child,
  });

  // TODO: Maybe make this platform specific?
  static const _defaultAmount = 8.0;

  /// The default amount of padding to use in [EdgePadding] at the given
  /// [context].
  static double of(BuildContext context) {
    final amount =
        context.dependOnInheritedWidgetOfExactType<DefaultPadding>()?.amount;
    return amount ?? _defaultAmount;
  }

  /// The default amount of padding to use in [EdgePadding]s below this widget.
  final double amount;

  @override
  bool updateShouldNotify(covariant DefaultPadding oldWidget) =>
      amount != oldWidget.amount;
}

typedef _PaddingAnimatableParameters = ({AnimatableEdgeInsetsGeometry padding});

/// Adds an equal [amount] of padding to specific [edges] around [child].
class EdgePadding extends SingleChildRenderObjectWidget
    with
        AnimatableSingleChildRenderObjectWidgetMixin<
            _PaddingAnimatableParameters> {
  /// Creates an [EdgePadding] widget.
  const EdgePadding({
    super.key,
    this.edges = Edge.all,
    this.amount,
    super.child,
  });

  /// The edges to add padding to.
  final Set<Edge> edges;

  /// The amount of padding to add.
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
    renderObject.padding = parameters.padding.animatedValue;
  }
}
