import 'package:flutter/widgets.dart' hide Animation;

import 'animatable_flutter_widgets.dart';
import 'animatable_widget.dart';
import 'animation.dart';
import 'common.dart';
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
///           return AColoredBox(color: active ? Colors.blue : Colors.grey);
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
/// {@category Animate}
T withAnimation<T>(AnimationSpec animation, Block<T> block) {
  return withTransaction(animation, block);
}

/// Mixin for the [State] of a [StatefulWidget] for conveniently applying
/// animations when making state changes.
///
/// {@category Animate}
mixin AnimatingStateMixin<T extends StatefulWidget> on State<T> {
  /// A version of [setState] that applies an [animation] to the state changes
  /// caused by calling [fn].
  ///
  /// See [Animated] for a widget that applies an animation **only to the state
  /// changes in its descendants**.
  ///
  /// This is simply a convenience method for calling [setState] within
  /// [withAnimation].
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
  ///       child: AColoredBox(color: _active ? Colors.blue : Colors.grey),
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
/// implement support for this in your own widgets use [AnimatableStateMixin] or
/// [AnimatableState].
///
/// The following provided widgets support animating with Fleet:
///
/// - [AAlign]
/// - [AColoredBox]
/// - [AContainer]
/// - [AOpacity]
/// - [APadding]
/// - [APositioned]
/// - [APositionedDirectional]
/// - [ASizedBox]
/// - [ASliverOpacity]
/// - [ASliverPadding]
/// - [ATransform]
///
/// {@endtemplate}
///
/// State changes are only animated if they happen at the same time that [value]
/// changes.
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
///         child: AColoredBox(color: _active ? Colors.blue : Colors.grey),
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
/// {@category Animate}
class Animated extends StatefulWidget {
  /// Creates a widget that applies an [animation] only to state changes in its
  /// descendants.
  const Animated({
    super.key,
    this.animation = const AnimationSpec(),
    required this.value,
    required this.child,
  });

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
    _animationIsActive = widget.value != oldWidget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Transaction(
      transaction: _animationIsActive ? widget.animation : null,
      child: widget.child,
    );
  }
}
