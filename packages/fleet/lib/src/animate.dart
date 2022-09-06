import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide Animation;

import 'animatable_flutter_widgets.dart';
import 'animatable_widget.dart';
import 'animation.dart';
import 'transaction.dart';

/// A concrete binding for applications based on the Widgets framework that use
/// the `fleet` package.
class FleetBinding extends BindingBase
    with
        GestureBinding,
        SchedulerBinding,
        ServicesBinding,
        PaintingBinding,
        SemanticsBinding,
        RendererBinding,
        TransactionBinding,
        WidgetsBinding {
  static FleetBinding? _instance;

  /// Ensures that the [FleetBinding] is initialized and returns it.
  static WidgetsBinding ensureInitialized() {
    if (FleetBinding._instance == null) {
      FleetBinding();
    }
    return WidgetsBinding.instance;
  }
}

/// Applies an [animation] to the state changes caused by calling [block].
///
/// To apply an animation **only to state changes in a widget subtree**, see
/// [Animated].
///
/// See [SetStateWithAnimationExtension.setStateWithAnimationAsync] for an
/// extension method for animating state changes in a [StatefulWidget].
///
/// During the next frame, [block] will be called and all state changes that
/// result from its execution will be animated with [animation].
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
///         withAnimationAsync(Curves.ease.animation(250.ms), () {
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
/// - [SetStateWithAnimationExtension.setStateWithAnimationAsync] for animating
///   state changes in a [StatefulWidget]'s [State].
/// - [Animated] for a widget that applies an [animation] to the state changes
///   in its descendants.
///
/// {@category Animate}
void withAnimationAsync(AnimationSpec animation, void Function() block) {
  final globalTransactionBinding = TransactionBinding.instance;
  if (globalTransactionBinding == null) {
    _debugWarnGlobalTransactionBindingIsNotInitialized();
    block();
  } else {
    Transaction.scheduleTransaction(animation, block);
  }
}

var _debugDidWarnGlobalTransactionsBindingIsNotInitialized = false;

void _debugWarnGlobalTransactionBindingIsNotInitialized() {
  assert(() {
    if (!_debugDidWarnGlobalTransactionsBindingIsNotInitialized) {
      _debugDidWarnGlobalTransactionsBindingIsNotInitialized = true;
      debugPrint(
        'GlobalTransactionBinding has not been initialized. Without it, '
        'withAnimationAsync, setStateWithAnimationAsync and Animate cannot apply the '
        'provided animation. Make sure you have called '
        'FleetBinding.ensureInitialized() before runApp.',
      );
    }
    return true;
  }());
}

/// Extension that adds a variant of [State.setState] that allows animating
/// state changes.
///
/// {@category Animate}
extension SetStateWithAnimationExtension on State {
  /// Applies an [animation] to the state changes caused by calling [block].
  ///
  /// See [Animated] for a widget that applies an animation **only to the state
  /// changes in its descendants**.
  ///
  /// During the next frame, [block] will be called within [setState] and all
  /// state changes that result from its execution will be animated with
  /// [animation].
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
  /// class _MyWidgetState extends State<MyWidget> {
  ///   var _active = false;
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return GestureDetector(
  ///       onTap: () {
  ///         setStateWithAnimationAsync(Curves.ease.animation(250.ms), () {
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
  /// - [withAnimationAsync] for a static function that works like this
  ///   extension method, but without calling [State.setState].
  /// - [Animated] for a widget that applies an animation to the state changes
  ///   in its descendants.
  @protected
  void setStateWithAnimationAsync(
    AnimationSpec animation,
    void Function() block,
  ) {
    // ignore: invalid_use_of_protected_member
    withAnimationAsync(animation, () => setState(block));
  }
}

/// A widget that applies an [animation] to state changes in its descendants.
///
/// See [withAnimationAsync] for a function that applies an animation to **all
/// state changes that are the result of calling a callback**.
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
/// changes. If no [value] is provided, every state change is animated.
///
/// [Animated] can be nested, with the closest enclosing [Animated] widget
/// taking precedence.
///
/// To negate the effects of an ancestor [Animated] widget for part of the
/// widget tree, wrap it in an [Animated] widget, with [animation] set to
/// `null`.
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
/// - [withAnimationAsync] for a function that applies an animation to the state
///   changes caused by calling a callback.
///
/// {@category Animate}
class Animated extends StatefulWidget {
  /// Creates a widget that applies an [animation] only to state changes in its
  /// descendants.
  const Animated({
    super.key,
    this.animation = const AnimationSpec(),
    this.value = _animateAllChanges,
    required this.child,
  });

  static const _animateAllChanges = Object();

  /// The [AnimationSpec] to use for animating state changes in descendants.
  final AnimationSpec? animation;

  /// When this value changes, coinciding state changes in descendants are
  /// animated.
  ///
  /// If no value is provided, all state changes are animated.
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
    _animationIsActive = widget.value == Animated._animateAllChanges ||
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
