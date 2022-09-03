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

/// Animates the state change caused by calling [block] with the provided
/// [animation].
///
/// During the next frame, [block] will be called and all visual changes that
/// result from its execution will be animated with [animation].
///
/// {@macro fleet.Animated.widgets}
///
/// # Example
///
/// ```dart
/// import 'package:flutter/material.dart';
///
/// final color = ValueNotifier(Colors.green);
///
/// class MyWidget extends StatelessWidget {
///   const MyWidget({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return GestureDetector(
///       onTap: () {
///         withAnimation(const AnimationSpec(), () {
///           color.value = Colors.red;
///         });
///       },
///       child: ValueListenableBuilder<Color>(
///         valueListenable: color,
///         builder: (context, color, _) {
///           return AColoredBox(color: color);
///         },
///       ),
///     );
///   }
/// }
/// ```
///
/// See also:
///
/// - [SetStateWithAnimationExtension.setStateWithAnimation] for animating state
///   changes in a [StatefulWidget]'s [State].
///
/// {@category Animate}
void withAnimation(AnimationSpec animation, void Function() block) {
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
        'withAnimation, setStateWithAnimation and Animate cannot apply the '
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
  /// Animates the state change caused by calling [block] with the provided
  /// [animation].
  ///
  /// During the next frame, [block] will be called within [setState] and all
  /// visual changes that result from its execution will be animated with
  /// [animation].
  ///
  /// {@macro fleet.Animated.widgets}
  ///
  /// # Example
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
  ///   var _color = Colors.green;
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return GestureDetector(
  ///       onTap: () {
  ///         setStateWithAnimation(const AnimationSpec(), () {
  ///           _color = Colors.red;
  ///         });
  ///       },
  ///       child: AColoredBox(color: _color),
  ///     );
  ///   }
  /// }
  /// ```
  @protected
  void setStateWithAnimation(AnimationSpec animation, void Function() block) {
    // ignore: invalid_use_of_protected_member
    withAnimation(animation, () => setState(block));
  }
}

/// Widget that animates changes in its widget subtree.
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
/// - [ASizedBox]
/// - [ASliverOpacity]
///
/// {@endtemplate}
///
/// Changes in this widgets subtree will be animated with the [animation] at the
/// time of the build in which the state change is detected.
///
/// If no [value] is provided every state change is animated. If a [value] is
/// provided state changes are only animated if the coincide with a change in
/// [value].
///
/// [Animated] can be nested, with the closest enclosing [Animated] widget
/// taking precedence. To negate the effects of an enclosing [Animated] widget
/// for part of the widget tree wrap it in an [Animated] widget, with
/// [animation] set to `null`.
///
/// {@category Animate}
class Animated extends StatefulWidget {
  /// Creates a widget that animates changes in its widget subtree.
  const Animated({
    super.key,
    this.animation = const AnimationSpec(),
    this.value = _animateAllChanges,
    required this.child,
  });

  static const _animateAllChanges = Object();

  /// The [AnimationSpec] to use for animating changes in this widget's subtree.
  final AnimationSpec? animation;

  /// When this value changes all coinciding state changes in the subtree are
  /// animated.
  ///
  /// If this value is `null` all state changes are animated.
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
