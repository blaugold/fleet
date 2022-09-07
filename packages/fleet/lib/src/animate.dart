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
/// See [AnimatingStateMixin.setStateAsync] for for animating state changes in a
/// [StatefulWidget].
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
/// - [AnimatingStateMixin.setStateAsync] for animating state changes in a
///   [StatefulWidget]'s [State].
/// - [Animated] for a widget that applies an [animation] to the state changes
///   in its descendants.
///
/// {@category Animate}
void withAnimationAsync(AnimationSpec animation, VoidCallback block) {
  _scheduleTransaction(animation, block);
}

void _scheduleTransaction(Object? transaction, VoidCallback block) {
  final globalTransactionBinding = TransactionBinding.instance;
  if (globalTransactionBinding == null) {
    _debugWarnGlobalTransactionBindingIsNotInitialized();
    block();
  } else {
    Transaction.scheduleTransaction(transaction, block);
  }
}

var _debugDidWarnGlobalTransactionsBindingIsNotInitialized = false;

void _debugWarnGlobalTransactionBindingIsNotInitialized() {
  assert(() {
    if (!_debugDidWarnGlobalTransactionsBindingIsNotInitialized) {
      _debugDidWarnGlobalTransactionsBindingIsNotInitialized = true;
      debugPrint(
        'GlobalTransactionBinding has not been initialized. Without it, '
        'withAnimationAsync, setStateAsync and Animate cannot '
        'apply the provided animation. Make sure you have called '
        'FleetBinding.ensureInitialized() before runApp.',
      );
    }
    return true;
  }());
}

/// Mixin for the [State] of a [StatefulWidget] that wants to apply animations
/// when calling [setState].
///
/// See [setStateAsync] for more information.
///
/// {@category Animate}
mixin AnimatingStateMixin<T extends StatefulWidget> on State<T> {
  @Deprecated(
    'Use setStateAsync instead of setState in a State that mixes in '
    'AnimatingStateMixin. This is required to ensure predictable ordering of '
    'state changes.',
  )
  @override
  void setState(VoidCallback fn) {
    throw UnsupportedError(
      'Use setStateAsync instead of setState in a State that mixes in '
      'AnimatingStateMixin. This is required to ensure predictable ordering of '
      'state changes.',
    );
  }

  /// A version of [setState] that invokes [fn] when Flutter builds the next
  /// frame.
  ///
  /// Within an [AnimatingStateMixin], this method must be used instead of
  /// [setState] to ensure state changes are applied in a predictable order.
  ///
  /// Since this method can be called when Flutter is not currently building a
  /// Frame, [fn] might be executed asynchronously. If this method is called
  /// while Flutter is building a frame, [fn] might be executed immediately.
  ///
  /// The callbacks of multiple calls to [setStateAsync] will be executed in the
  /// same order as the calls to [setStateAsync].
  ///
  /// # Animations
  ///
  /// This method optionally applies an [animation] to the state changes caused
  /// by calling [fn].
  ///
  /// See [Animated] for a widget that applies an animation **only to the state
  /// changes in its descendants**.
  ///
  /// All state changes that result from the execution of [fn] will be animated
  /// with [animation].
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
  ///         setStateAsync(animation: Curves.ease.animation(250.ms), () {
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
  void setStateAsync(VoidCallback fn, {AnimationSpec? animation}) {
    _scheduleTransaction(animation, () => super.setState(fn));
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
