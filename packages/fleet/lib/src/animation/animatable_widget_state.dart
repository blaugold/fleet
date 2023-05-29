import 'package:flutter/widgets.dart';

import 'parameter.dart';

/// Mixin for the [State] of a widget that supports animating with Fleet.
///
/// To support animating with Fleet, a widget needs to be able to detect changes
/// in its parameters. That means it has to be a [StatefulWidget]. This mixin is
/// meant to be mixed in to the state class of such a widget and builds on
/// [AnimatableParameterHostMixin], so it has to be mixed into the state class
/// as well. It is usually easier to extend the widget's state class from
/// [AnimatableState], wich already mixes in the mentioned mixins.
///
/// Not every parameter of a widget can be animated. Values of discrete types,
/// like [Enum]s, cannot be interpolated between.
///
/// The state class needs to contain an [AnimatableParameter] for each parameter
/// that can and should be animatable. You need to use a subclass of
/// [AnimatableParameter] that is specific to the parameter, e.g.
/// [AnimatableColor] for [Color]s. If the parameter is optional, you need to
/// use the corresponding subclass that supports `null` values, e.g.
/// [OptionalAnimatableColor].
///
/// In the [build] method, use [AnimatableParameter.animatedValue] to get the
/// current value of a parameter.
///
/// When the widget is rebuilt, [updateAnimatableParameters] is called, in which
/// you have to update the [AnimatableParameter]s with the new values.
///
/// # Examples
///
/// ```dart
/// import 'package:flutter/widgets.dart';
///
/// class Square extends StatefulWidget {
///   Square({super.key, required this.dimension, required this.child});
///
///   final double dimension;
///   final Widget child;
///
///   @override
///   _SquareState createState() => _SquareState();
/// }
///
/// class _SquareState extends State<Square>
///     with AnimatableParameterHostMixin, AnimatableStateMixin {
///   late final _dimension = AnimatableDouble(widget.dimension, host: this);
///
///   @override
///   void updateAnimatableParameters() {
///     _dimension.value = widget.dimension;
///   }
///
///   @protected
///   Widget build(BuildContext context) {
///     return SizedBox.square(
///       dimension: _dimension.animatedValue,
///       child: widget.child,
///     );
///   }
/// }
/// ```
///
/// See also:
///
/// - [AnimatableState] for a [State] class that already mixes in
///   [AnimatableStateMixin] and [AnimatableParameterHostMixin].
///
/// {@category Animation}
mixin AnimatableStateMixin<T extends StatefulWidget>
    on State<T>, AnimatableParameterHostMixin {
  @override
  void animatableParameterChanged() => setState(() {});

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    applyUpdateToAnimatableParameters();
  }

  @override
  void activate() {
    activateAnimatableParameterHost();
    super.activate();
  }

  @override
  void dispose() {
    disposeAnimatableParametersHost();
    super.dispose();
  }
}

/// Convenience [State] base class for widgets that use [AnimatableParameter]s
/// to transparently animate their parameters.
///
/// Extend your state class from this class instead of mixing
/// [AnimatableParameterHostMixin] and [AnimatableStateMixin] into the state
/// class.
///
/// {@category Animation}
abstract class AnimatableState<T extends StatefulWidget> extends State<T>
    with AnimatableParameterHostMixin, AnimatableStateMixin<T> {}
