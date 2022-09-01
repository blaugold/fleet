import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide Animation;

import 'animated_widget.dart';
import 'animated_widgets.dart';
import 'animation.dart';
import 'transaction.dart';

/// A concrete binding for applications based on the Widgets framework that use
/// the `animated_value` package.
class AnimatedValueBinding extends BindingBase
    with
        GestureBinding,
        SchedulerBinding,
        ServicesBinding,
        PaintingBinding,
        SemanticsBinding,
        RendererBinding,
        TransactionBinding,
        WidgetsBinding {
  static AnimatedValueBinding? _instance;

  /// Ensures that the [AnimatedValueBinding] is initialized and returns it.
  static WidgetsBinding ensureInitialized() {
    if (AnimatedValueBinding._instance == null) {
      AnimatedValueBinding();
    }
    return WidgetsBinding.instance;
  }
}

/// Schedules an animated state change to be applied during the next frame.
///
/// During the next frame, [block] will be executed and all changes of
/// animatable values that result from its execution, will be animated with
/// [animation].
///
/// {@macro animated_value.Animated.widgets}
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
        'AnimatedValueBinding.ensureInitialized() before runApp.',
      );
    }
    return true;
  }());
}

/// Extension that adds a variant of [State.setState] that allows animating
/// state changes.
extension SetStateWithAnimationExtension on State {
  /// Schedules an animated change of this [State] to be applied during the next
  /// frame.
  ///
  /// During the next frame, [block] will be executed within [setState] and all
  /// changes of animatable values that result from its execution, will be
  /// animated with [animation].
  ///
  /// {@macro animated_value.Animated.widgets}
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
/// {@template animated_value.Animated.widgets}
///
/// Only widgets which participate in state-based animation of parameters will
/// animate changes. To implement support for this in your own widgets use
/// [AnimatedWidgetStateMixin] or [AnimatedWidgetState].
///
/// The following provided widgets support state-based animation of parameters:
///
/// - [AAlign]
/// - [AColoredBox]
/// - [AContainer]
/// - [ASizedBox]
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
