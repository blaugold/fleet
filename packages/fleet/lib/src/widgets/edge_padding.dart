// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../animatable_render_object_widget.dart';
import '../environment.dart';
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
}

/// Combinations of [Edge]s.
abstract final class Edges {
  /// Set of all edges.
  static const all = {Edge.top, Edge.bottom, Edge.start, Edge.end};

  /// Set of all edges along the vertical axis.
  static const vertical = {Edge.top, Edge.bottom};

  /// Set of all edges along the horizontal axis.
  static const horizontal = {Edge.start, Edge.end};

  /// Set that contains only the [Edge.start] edge.
  static const start = {Edge.start};

  /// Set that contains only the [Edge.end] edge.
  static const end = {Edge.end};

  /// Set that contains only the [Edge.top] edge.
  static const top = {Edge.top};

  /// Set that contains only the [Edge.bottom] edge.
  static const bottom = {Edge.bottom};
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

final class _DefaultPaddingKey
    extends EnvironmentKey<double, _DefaultPaddingKey> {
  const _DefaultPaddingKey();

  @override
  double defaultValue(BuildContext context) => 8;
}

/// [EnvironmentKey] for the default amount of padding to use in [EdgePadding].
///
/// {@template fleet.defaultPadding}
/// [defaultPadding] is used by [EdgePadding] to determine the amount of padding
/// to add when [EdgePadding.amount] is `null`.
///
/// The default value is `8`.
/// {@endtemplate}
const defaultPadding = _DefaultPaddingKey();

typedef _PaddingAnimatableParameters = ({AnimatableEdgeInsetsGeometry padding});

/// Adds an equal [amount] of padding to specific [edges] around [child].
final class EdgePadding extends SingleChildRenderObjectWidget
    with
        AnimatableSingleChildRenderObjectWidgetMixin<
            _PaddingAnimatableParameters> {
  /// Creates an [EdgePadding] widget.
  const EdgePadding({
    super.key,
    this.edges = Edges.all,
    this.amount,
    super.child,
  });

  /// The edges to add padding to.
  final Set<Edge> edges;

  /// The amount of padding to add.
  final double? amount;

  EdgeInsetsGeometry _resolvePadding(BuildContext context) =>
      edges.toEdgeInsets(amount ?? defaultPadding.of(context));

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

/// Extension-based API for [EdgePadding].
extension EdgePaddingModifiers on Widget {
  /// Sets the [defaultPadding] to [amount] for this widget and its descendants.
  ///
  /// {@macro fleet.defaultPadding}
  @widgetFactory
  Widget defaultPadding(double amount) =>
      const _DefaultPaddingKey().update(value: amount, child: this);

  /// Adds an equal [amount] of padding to specific [edges] of this widget.
  @widgetFactory
  Widget padding([Set<Edge> edges = Edges.all, double? amount]) {
    return EdgePadding(
      edges: edges,
      amount: amount,
      child: this,
    );
  }
}
