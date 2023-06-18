import 'package:flutter/widgets.dart' hide Animation;

import '../common.dart';
import '../widgets/flutter/basic.dart';
import '../widgets/flutter/container.dart';
import '../widgets/uniform_padding.dart';
import 'animatable_render_object_widget.dart';
import 'animatable_stateless_widget.dart';
import 'animation.dart';
import 'transaction.dart';

/// Applies an [animation] to the state changes caused by calling [block].
///
/// To apply an animation **only to state changes in a widget subtree**, see
/// [Animated].
///
/// See [AnimatingStateMixin] for conveniently animating state changes in a
/// [StatefulWidget].
///
/// Returns the value returned by [block].
///
/// {@macro fleet.Animated.widgets}
///
/// # Examples
///
/// ```dart
/// import 'package:flutter/material.dart';
///
/// final active = ValueNotifier(false);
///
/// class MyWidget extends StatelessWidget {
///   const MyWidget({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return GestureDetector(
///       onTap: () {
///         withAnimation(Curves.ease.animation(250.ms), () {
///           active.value = !active.value;
///         });
///       },
///       child: ValueListenableBuilder<bool>(
///         valueListenable: active,
///         builder: (context, active, _) {
///           return FleetColoredBox(color: active ? Colors.blue : Colors.grey);
///         },
///       ),
///     );
///   }
/// }
/// ```
///
/// See also:
///
/// - [AnimatingStateMixin] for conveniently animating state changes in a
///   [StatefulWidget].
/// - [Animated] for a widget that applies an [animation] to the state changes
///   in its descendants.
///
/// {@category Animation}
T withAnimation<T>(AnimationSpec animation, Block<T> block) {
  return withTransaction(animation, block);
}

/// Mixin for the [State] of a [StatefulWidget] for conveniently applying
/// animations when making state changes.
///
/// {@category Animation}
mixin AnimatingStateMixin<T extends StatefulWidget> on State<T> {
  /// A version of [setState] that applies an [animation] to the state changes
  /// caused by calling [fn].
  ///
  /// See [Animated] for a widget that applies an animation **only to the state
  /// changes in its descendants**.
  ///
  /// This is simply a convenience method for calling [setState] within
  /// [withAnimation]
  ///
  /// <!--
  /// ```dart multi_begin
  /// void setState(void Function() fn) {}
  /// ```
  /// -->
  ///
  /// ```dart multi_end main
  /// withAnimation(const AnimationSpec(), () {
  ///   setState(() {
  ///     // Change state...
  ///   });
  /// });
  /// ```
  ///
  /// But it is usually more convenient to use this method.
  ///
  /// {@macro fleet.Animated.widgets}
  ///
  /// # Examples
  ///
  /// ```dart
  /// import 'package:flutter/material.dart';
  ///
  /// class MyWidget extends StatefulWidget {
  ///   const MyWidget({super.key});
  ///
  ///   @override
  ///   State<MyWidget> createState() => _MyWidgetState();
  /// }
  ///
  /// class _MyWidgetState extends State<MyWidget> with AnimatingStateMixin {
  ///   var _active = false;
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return GestureDetector(
  ///       onTap: () {
  ///         setStateWithAnimation(Curves.ease.animation(250.ms), () {
  ///           _active = !_active;
  ///         });
  ///       },
  ///       child: FleetColoredBox(color: _active ? Colors.blue : Colors.grey),
  ///     );
  ///   }
  /// }
  /// ```
  ///
  /// See also:
  ///
  /// - [withAnimation] for a static function that applies an animation to the
  ///   state changes caused by calling a callback.
  /// - [Animated] for a widget that applies an animation to the state changes
  ///   in its descendants.
  @protected
  void setStateWithAnimation(AnimationSpec animation, VoidCallback fn) {
    withAnimation(animation, () => super.setState(fn));
  }
}

/// A widget that applies an [animation] to state changes in its descendants.
///
/// See [withAnimation] for a function that applies an animation to **all state
/// changes that are the result of calling a callback**.
///
/// {@template fleet.Animated.widgets}
///
/// Only widgets that support animating with Fleet will animate changes. To
/// implement support for this in your own widgets use
/// [AnimatableStatelessWidget] or
/// [AnimatableSingleChildRenderObjectWidgetMixin].
///
/// The following provided widgets support animating with Fleet:
///
/// - [FleetAlign]
/// - [FleetAspectRatio]
/// - [FleetCenter]
/// - [FleetColoredBox]
/// - [FleetColumn]
/// - [FleetContainer]
/// - [FleetDecoratedBox]
/// - [FleetFlex]
/// - [FractionalTranslation]
/// - [FleetFractionallySizedBox]
/// - [FleetOpacity]
/// - [FleetPadding]
/// - [FleetPositioned]
/// - [FleetPositionedDirectional]
/// - [FleetRow]
/// - [FleetSizedBox]
/// - [FleetSliverOpacity]
/// - [FleetSliverPadding]
/// - [FleetTransform]
///
/// The following provided widgets are specific to Fleet:
///
/// - [UniformPadding]
///
/// {@endtemplate}
///
/// State changes are only animated if they happen at the same time that [value]
/// changes. If no [value] or the [alwaysAnimateValue] is provided, the
/// [animation] is applied to all state changes.
///
/// [Animated] can be nested, with the closest enclosing [Animated] widget
/// taking precedence.
///
/// # Examples
///
/// ```dart
/// import 'package:flutter/material.dart';
///
/// class MyWidget extends StatefulWidget {
///   const MyWidget({super.key});
///
///   @override
///   State<MyWidget> createState() => _MyWidgetState();
/// }
///
/// class _MyWidgetState extends State<MyWidget> {
///   var _active = false;
///
///   @override
///   Widget build(BuildContext context) {
///     return GestureDetector(
///       onTap: () {
///         setState(() {
///           _active = !_active;
///         });
///       },
///       child: Animated(
///         animation: Curves.ease.animation(250.ms),
///         value: _active,
///         child: FleetColoredBox(color: _active ? Colors.blue : Colors.grey),
///       ),
///     );
///   }
/// }
/// ```
///
/// See also:
///
/// - [withAnimation] for a function that applies an animation to the state
///   changes caused by calling a callback.
///
/// {@category Animation}
class Animated extends StatefulWidget {
  /// Creates a widget that applies an [animation] only to state changes in its
  /// descendants.
  const Animated({
    super.key,
    this.animation = const AnimationSpec(),
    this.value = alwaysAnimateValue,
    required this.child,
  });

  /// A [value] that can be provided to animate all state changes in
  /// descendants.
  static const alwaysAnimateValue = Object();

  /// The [AnimationSpec] to use for animating state changes in descendants.
  final AnimationSpec animation;

  /// When this value changes, coinciding state changes in descendants are
  /// animated.
  final Object? value;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  State<Animated> createState() => _AnimatedState();
}

class _AnimatedState extends State<Animated> {
  var _animationIsActive = false;

  @override
  void didUpdateWidget(covariant Animated oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animationIsActive = identical(widget.value, Animated.alwaysAnimateValue) ||
        widget.value != oldWidget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Transaction(
      transaction: _animationIsActive ? widget.animation : null,
      child: widget.child,
    );
  }
}
