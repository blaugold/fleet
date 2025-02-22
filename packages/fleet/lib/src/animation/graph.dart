import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// An value that can participate in an animation graph.
final class Value<T> extends Animation<T>
    with
        AnimationLocalListenersMixin,
        AnimationLocalStatusListenersMixin,
        AnimationEagerListenerMixin {
  /// Creates a value that can participate in an animation graph.
  Value({
    this.name,
    required T value,
  }) : _value = value;

  /// The name of this value for debugging purposes.
  final String? name;

  AnimationStatus _status = AnimationStatus.dismissed;

  @override
  AnimationStatus get status => _status;

  set status(AnimationStatus status) {
    if (_status != status) {
      _status = status;
      notifyStatusListeners(status);
    }
  }

  T _value;

  @override
  T get value => _value;

  set value(T value) {
    if (_value != value) {
      _value = value;
      notifyListeners();
    }
  }

  /// Creates an [AnimationNode] that set this [Value.value] to a new [value]
  /// without animating.
  AnimationNode jump(T value) => ValueJump(value: this, to: value);
}

/// A [Value] that defines a tween to animate between states of the value.
final class TweenValue<T> extends Value<T> {
  /// Creates a [Value] that defines a tween to animate between states of the
  /// value.
  TweenValue({
    super.name,
    required super.value,
    required this.tweenFactory,
  });

  /// Creates an [TweenValue] with type [double], that uses [Tween] to animate
  /// between states of the value.
  static TweenValue<double> double$({
    String? name,
    double value = 0,
  }) {
    return TweenValue(
      name: name,
      value: value,
      tweenFactory: Tween.new,
    );
  }

  /// Creates an [TweenValue] with type [int], that uses [IntTween] to animate
  /// between states of the value.
  static TweenValue<int> int$({
    String? name,
    int value = 0,
  }) {
    return TweenValue(
      name: name,
      value: value,
      tweenFactory: IntTween.new,
    );
  }

  /// Creates an [TweenValue] with type [Color], that uses [ColorTween] to
  /// animate between states of the value.
  static TweenValue<Color> color({
    String? name,
    Color value = const Color(0x00000000),
  }) {
    return TweenValue(
      name: name,
      value: value,
      tweenFactory: ColorTween.new,
    );
  }

  /// Creates an [TweenValue] with type [Offset], that uses [Tween] to
  /// animate between states of the value.
  static TweenValue<Offset> offset({
    String? name,
    Offset value = Offset.zero,
  }) {
    return TweenValue(
      name: name,
      value: value,
      tweenFactory: Tween.new,
    );
  }

  /// A factory for creating a tween to animate between states of this value.
  final Tween<T?> Function() tweenFactory;

  /// Creates an [AnimationNode] that animates this value to a new [value].
  ///
  /// If [from] is provided, the animation will start from that value. Otherwise
  /// the animation will start from the current value.
  ///
  /// The animation will have a duration of [over].
  ///
  /// The animation will use the specified [curve] (defaults to
  /// [Curves.linear]).
  AnimationNode to(
    T value, {
    T? from,
    // TODO: Consider alternatives to name of parameter `over`.
    Duration? over,
    Curve? curve,
  }) {
    return TweenValueAnimation(
      value: this,
      from: from,
      to: value,
      duration: over,
      curve: curve,
    );
  }
}

/// Convenience extensions for [TweenValue]s that have [double] as their
/// type.
extension DoubleTweenValueExtension on TweenValue<double> {
  /// Creates an [AnimationNode] that animates this value to to `1.0`.
  AnimationNode forward({
    Duration? over,
    double? from,
    Curve? curve,
  }) =>
      to(1, over: over, from: from, curve: curve);

  /// Creates an [AnimationNode] that animates this value to to `0.0`.
  AnimationNode reverse({
    Duration? over,
    double? from,
    Curve? curve,
  }) =>
      to(0, over: over, from: from, curve: curve);
}

/// A node in an animation graph.
///
/// A node is an immutable configuration for an [AnimationElement]. The same
/// node can be reused and run multiple times with
/// [AnimationGraphController.animate].
// ignore: one_member_abstracts
abstract class AnimationNode {
  /// Creates an [AnimationElement] that will be used to run this node in an
  /// animation graph.
  AnimationElement createElement();
}

/// A callback that is called when an [AnimationElement] exits.
///
/// The [elapsedAfterExit] parameter is the duration that has elapsed since the
/// [AnimationElement] has exited and the current tick.
typedef OnExitCallback = void Function(Duration elapsedAfterExit);

void _noOpOnExit(Duration elapsedAfterExit) {}

/// Represents the instantiation of an [AnimationNode] in an animation
/// graph when running an animation node.
abstract class AnimationElement {
  /// The [GraphAnimation] that this element belongs to.
  late final GraphAnimation animation;

  /// Whether this element is the root element of the animation graph.
  bool get isRoot => false;

  /// The parent element of this element in the animation graph.
  AnimationElement get parent => _parent;
  late final AnimationElement _parent;

  /// The [AnimationNode] that this element was created from.
  AnimationNode get node;

  /// The callback that is called when this element exits.
  OnExitCallback onExit = _noOpOnExit;

  /// The method that is called on every animation frame to update the state of
  /// this element.
  ///
  /// [elapsed] is the duration that has elapsed since this element has started
  /// animating.
  ///
  /// Conceptional every element starts animating from a duration of zero. But
  /// the first call to [tick] can have a non-zero duration if for example a
  /// previous element has complete its animation between frames. In this case
  /// [elapsed] of the first call to [tick] is the duration that has elapsed
  /// since the previous element has completed and the current frame.
  // TODO: Add parameter to indicate that time is running backwards.
  void tick(Duration elapsed);

  /// Disposes this element and all its children.
  ///
  /// If dispose is called before this element has exited, the element is
  /// supposed to cancel its animation and not call [onExit].
  void dispose();

  /// Finds the parent element of this element that is of the given type [T].
  ///
  /// Returns `null` if no parent of the given type is found.
  T? findParentOfType<T extends AnimationElement>() {
    final parent = this.parent;

    if (parent is T) {
      return parent;
    }

    if (parent.isRoot) {
      return null;
    }

    return parent.findParentOfType<T>();
  }

  /// Creates a child element for the given [node].
  @protected
  AnimationElement createChild(AnimationNode node) => node.createElement()
    .._parent = this
    ..animation = animation;
}

/// Extension methods for [AnimationNode].
extension AnimationNodeExtension on AnimationNode {
  /// Returns a new animation node that runs all contained animation nodes at
  /// the given [speed].
  AnimationNode speed(double speed) => Speed(speed, this);

  /// Returns a new animation node that delays the start of this animation by
  /// the specified [duration].
  AnimationNode delay(Duration duration) => Delay(duration, this);
}

/// A group of animation nodes that are started and run in parallel.
final class Group extends AnimationNode {
  /// Creates a group of [children] that are started and run in parallel.
  Group(this.children);

  /// The children of this group, which are started and run in parallel.
  final List<AnimationNode> children;

  @override
  AnimationElement createElement() => _GroupElement(this);
}

class _GroupElement extends AnimationElement {
  _GroupElement(this.node);

  @override
  final Group node;

  final List<AnimationElement> _children = [];
  final List<Duration> _elapsedAfterExitsInCurrentTick = [];

  @override
  void tick(Duration elapsed) {
    if (node.children.isEmpty) {
      onExit.call(elapsed);
      return;
    }

    if (_children.isEmpty) {
      for (final childNode in node.children) {
        final child = createChild(childNode);
        _children.add(child);
        child.onExit = (elapsed) => _onChildExit(child, elapsed);
      }
    }

    _elapsedAfterExitsInCurrentTick.clear();
    for (final child in List.of(_children)) {
      child.tick(elapsed);
    }
  }

  void _onChildExit(AnimationElement child, Duration elapsedAfterExit) {
    _elapsedAfterExitsInCurrentTick.add(elapsedAfterExit);
    _children.remove(child);
    child.dispose();
    if (_children.isEmpty) {
      final minElapsedAfterExit =
          _elapsedAfterExitsInCurrentTick.reduce((a, b) => a < b ? a : b);
      onExit.call(minElapsedAfterExit);
    }
  }

  @override
  void dispose() {
    for (final child in _children) {
      child.dispose();
    }
  }
}

/// A sequence of animation nodes that are started and run in sequence.
final class Sequence extends AnimationNode {
  /// Creates a sequence of [children] that are started and run in sequence.
  Sequence(this.children);

  /// The children of this sequence, which are started and run in sequence.
  final List<AnimationNode> children;

  @override
  AnimationElement createElement() => _SequenceElement(this);
}

class _SequenceElement extends AnimationElement {
  _SequenceElement(this.node);

  @override
  final Sequence node;

  int _index = 0;
  AnimationElement? _currentChild;
  Duration _currentElapsed = Duration.zero;
  Duration _elapsedBeforeCurrentChild = Duration.zero;

  @override
  void tick(Duration elapsed) {
    if (_currentChild == null) {
      _onNextChild(elapsed);
    }

    _currentElapsed = elapsed;
    _currentChild?.tick(elapsed - _elapsedBeforeCurrentChild);
  }

  void _onNextChild(Duration elapsedAfterExit) {
    _currentChild?.dispose();

    if (_index >= node.children.length) {
      onExit.call(elapsedAfterExit);
      return;
    }

    final child = createChild(node.children[_index++]);
    _currentChild = child;
    child.onExit = _onChildExit;
  }

  void _onChildExit(Duration elapsedAfterExit) {
    _elapsedBeforeCurrentChild = _currentElapsed - elapsedAfterExit;
    _onNextChild(elapsedAfterExit);
  }

  @override
  void dispose() => _currentChild?.dispose();
}

/// A node that immediately sets [value] to a new value without animating.
final class ValueJump<T> extends AnimationNode {
  /// Creates a value jump node that immediately sets [value] to a new value
  ValueJump({required this.value, required this.to});

  /// The value to set to a new value.
  final Value<T> value;

  /// The value to set the [value] to.
  final T to;

  @override
  AnimationElement createElement() => _ValueJumpElement(this);
}

final class _ValueJumpElement<T> extends AnimationElement {
  _ValueJumpElement(this.node);

  @override
  final ValueJump<T> node;

  @override
  void tick(Duration elapsed) {
    node.value
      ..value = node.to
      ..status = AnimationStatus.completed;
    onExit(elapsed);
  }

  @override
  void dispose() {}
}

/// A node that provides default values for unspecified [TweenValueAnimation]
/// parameters to its [child] sub-graph.
final class ValueAnimationDefaults extends AnimationNode {
  /// Creates a value animation defaults node that provides default values for
  /// unspecified [TweenValueAnimation] parameters to its [child] sub-graph.
  ValueAnimationDefaults(
    this.child, {
    this.duration,
    this.curve,
  });

  /// The default duration for [TweenValueAnimation.duration].
  static const defaultDuration = Duration(milliseconds: 300);

  /// The default curve for [TweenValueAnimation.curve].
  static const defaultCurve = Curves.linear;

  static ValueAnimationDefaults? _defaultOf(AnimationElement element) =>
      element.findParentOfType<_ValueAnimationDefaultsElement>()?.node;

  static Duration _durationOf(AnimationElement element) =>
      _defaultOf(element)?.duration ?? defaultDuration;

  static Curve _curveOf(AnimationElement element) =>
      _defaultOf(element)?.curve ?? defaultCurve;

  /// The default duration for [TweenValueAnimation.duration].
  final Duration? duration;

  /// The default curve for [TweenValueAnimation.curve].
  final Curve? curve;

  /// The animation sub-graph to apply the defaults within.
  final AnimationNode child;

  @override
  AnimationElement createElement() => _ValueAnimationDefaultsElement(this);
}

final class _ValueAnimationDefaultsElement extends AnimationElement {
  _ValueAnimationDefaultsElement(this.node);

  @override
  final ValueAnimationDefaults node;

  AnimationElement? _child;

  @override
  void tick(Duration elapsed) {
    _child ??= createChild(node.child);
    _child!.tick(elapsed);
  }

  @override
  void dispose() {
    _child?.dispose();
  }
}

/// An animation node that animates an [Value].
final class TweenValueAnimation<T> extends AnimationNode {
  /// Creates a value animation that animates the given [value].
  TweenValueAnimation({
    required this.value,
    this.from,
    required this.to,
    this.duration,
    this.curve,
  });

  /// The value to animate.
  final TweenValue<T> value;

  /// The value to start the animation from.
  final T? from;

  /// The value to animate to.
  final T to;

  /// The duration over which to animate the [value].
  final Duration? duration;

  /// The curve to use for the animation.
  final Curve? curve;

  @override
  AnimationElement createElement() => _TweenValueAnimationElement(this);
}

class _TweenValueAnimationElement<T> extends AnimationElement {
  _TweenValueAnimationElement(this.node);

  @override
  final TweenValueAnimation<T> node;

  Tween<T?>? _tween;

  @override
  void tick(Duration elapsed) {
    _tween ??= node.value.tweenFactory()
      ..begin = node.from ?? node.value.value
      ..end = node.to;

    final duration = node.duration ?? ValueAnimationDefaults._durationOf(this);
    if (duration == Duration.zero) {
      node.value.value = node.to;
      onExit(elapsed);
      return;
    } else {
      final curve = node.curve ?? ValueAnimationDefaults._curveOf(this);
      final effectiveElapsed = elapsed > duration ? duration : elapsed;

      final elapsedAfterExit = elapsed - duration;
      final completed = elapsedAfterExit >= Duration.zero;

      final progress = curve
          .transform(effectiveElapsed.inMilliseconds / duration.inMilliseconds)
          .clamp(0.0, 1.0);
      final value = _tween!.transform(progress) as T;
      node.value
        ..value = value
        ..status =
            completed ? AnimationStatus.completed : AnimationStatus.forward;

      if (completed) {
        onExit(elapsedAfterExit);
      }
    }
  }

  @override
  void dispose() {}
}

/// An animation node that pauses for a specified duration.
final class Pause extends Delay {
  /// Creates a pause animation that pauses for the specified [duration].
  Pause(super.duration);
}

/// An animation node that delays the start of a [child] animation by a
/// specified [duration].
///
/// If the [child] animation is not provided, this node will simply
/// complete after the specified [duration].
final class Delay extends AnimationNode {
  /// Creates a delay animation that delays the start of a [child] animation by
  /// the specified [duration].
  Delay(this.duration, [this.child]);

  /// The duration to delay the start of the [child] animation.
  final Duration duration;

  /// The child animation to delay.
  final AnimationNode? child;

  @override
  AnimationElement createElement() => _DelayElement(this);
}

class _DelayElement extends AnimationElement {
  _DelayElement(this.node);

  @override
  final Delay node;

  AnimationElement? _child;

  @override
  void tick(Duration elapsed) {
    if (elapsed >= node.duration) {
      final effectiveElapsed = elapsed - node.duration;
      final childNode = node.child;
      if (childNode != null) {
        _child ??= createChild(childNode)..onExit = onExit;
        _child!.tick(effectiveElapsed);
      } else {
        onExit(effectiveElapsed);
      }
    }
  }

  @override
  void dispose() => _child?.dispose();
}

/// An animation node that changes the speed with which its [child] animation
/// animates.
final class Speed extends AnimationNode {
  /// Creates a speed animation that changes the speed with which its [child]
  /// animation animates.
  Speed(this.speed, this.child);

  /// The speed with which the [child] animation animates.
  ///
  /// A speed of `1.0` is as if the animation is running at normal speed. A
  /// speed of `2.0` is as if the animation is running at double speed.
  /// A speed of `0.5` is as if the animation is running at half speed.
  final double speed;

  /// The child animation to change the speed of.
  final AnimationNode child;

  @override
  AnimationElement createElement() => _SpeedElement(this);
}

class _SpeedElement extends AnimationElement {
  _SpeedElement(this.node);

  @override
  final Speed node;

  AnimationElement? _child;

  @override
  void tick(Duration elapsed) {
    _child ??= createChild(node.child)
      ..onExit = (elapsedAfterExit) {
        onExit(
          Duration(
            microseconds:
                (elapsedAfterExit.inMicroseconds.toDouble() / node.speed)
                    .round(),
          ),
        );
      };

    _child!.tick(elapsed * node.speed);
  }

  @override
  void dispose() {}
}

/// An animation node that immediately runs an [action] and waits for it to
/// complete.
final class Action extends AnimationNode {
  /// Creates an action animation that immediately runs an [action] and waits
  /// for it to complete.
  Action(this.action);

  /// The action to run.
  ///
  /// The action can be asynchronous and can return a [Future]. In this case
  /// this animation node will wait for the future to complete before
  /// completing.
  final FutureOr<void> Function() action;

  @override
  AnimationElement createElement() => _ActionElement(this);
}

enum _ActionState {
  idle,
  running,
  completed,
}

class _ActionElement extends AnimationElement {
  _ActionElement(this.node);

  @override
  final Action node;

  _ActionState _state = _ActionState.idle;
  late DateTime _endTime;

  @override
  void tick(Duration elapsed) {
    switch (_state) {
      case _ActionState.idle:
        Future.sync(() async {
          _state = _ActionState.running;
          try {
            final result = node.action();
            if (result is Future<void>) {
              await result;
            }
          } catch (error, stackTrace) {
            FlutterError.reportError(
              FlutterErrorDetails(
                exception: error,
                stack: stackTrace,
                library: 'fleet',
                context: ErrorDescription('while running action'),
              ),
            );
          } finally {
            _endTime = clock.now();
            _state = _ActionState.completed;
          }
        });
      case _ActionState.running:
        break;
      case _ActionState.completed:
        onExit.call(_endTime.difference(clock.now()));
    }
  }

  @override
  void dispose() {}
}

/// A controller for running animation graph animations.
class AnimationGraphController {
  /// Creates an animation graph controller.
  AnimationGraphController({required this.vsync}) {
    _ticker = vsync.createTicker(_tick);
  }

  /// The ticker provider for creating tickers for animations.
  final TickerProvider vsync;

  late final Ticker _ticker;

  final _runningAnimations = <GraphAnimation>[];

  /// Starts the animation graph specified by the given [node] node.
  ///
  /// Returns a [GraphAnimation] that can be used to wait for the animation to
  /// complete or to cancel it.
  GraphAnimation animate(AnimationNode node) {
    final animation = GraphAnimation._(this, node);
    animation._mount();
    return animation;
  }

  /// Cancels all running animations.
  void cancelAll() {
    for (final animation in List.of(_runningAnimations)) {
      animation.dispose();
    }
  }

  /// Disposes this controller and cancels all running animations.
  void dispose() {
    cancelAll();
    _ticker.dispose();
  }

  void _attach(GraphAnimation animation) {
    if (_runningAnimations.isEmpty) {
      _ticker.start();
    }
    _runningAnimations.add(animation);
  }

  void _detach(GraphAnimation stateMachine) {
    _runningAnimations.remove(stateMachine);
    if (_runningAnimations.isEmpty) {
      _ticker.stop();
    }
  }

  void _tick(Duration elapsed) {
    for (final animation in List.of(_runningAnimations)) {
      animation.tick(elapsed);
    }
  }
}

/// An animation that executes the graph animation specified by a [node]
/// animation node.
///
/// You can wait for the animation to complete by awaiting the [done] future.
/// This future will complete when the animation has completed but not when it
/// has been canceled.
///
/// You can also await the [doneOrCanceled] future, which will complete when the
/// animation has completed or has been canceled.
final class GraphAnimation extends AnimationElement {
  GraphAnimation._(this.controller, this.node);

  /// The animation graph controller this animation belongs to.
  final AnimationGraphController controller;

  /// The root animation node of this animation.
  @override
  final AnimationNode node;

  /// The animation element that has been created from the root animation node.
  late final AnimationElement element;

  final _doneCompleter = Completer<void>();
  final _doneOrDisposedCompleter = Completer<bool>();

  @override
  bool get isRoot => true;

  /// A future that completes when the animation has completed.
  Future<void> get done => _doneCompleter.future;

  /// A future that completes when the animation has completed or has been
  /// canceled.
  ///
  /// If the animation has completed, the future will complete with `true`. If
  /// the animation has been canceled, the future will complete with `false`.
  Future<bool> get doneOrCanceled => _doneOrDisposedCompleter.future;

  void _mount() {
    element = node.createElement()
      ..onExit = (elapsedAfterExit) {
        _doneCompleter.complete();
        dispose();
      }
      ..animation = this;
    controller._attach(this);
  }

  @override
  void tick(Duration elapsed) => element.tick(elapsed);

  /// Disposes the animation. If it is still running it will be canceled.
  @override
  void dispose() {
    if (_doneOrDisposedCompleter.isCompleted) {
      return;
    }

    element.dispose();
    controller._detach(this);
    _doneOrDisposedCompleter.complete(_doneCompleter.isCompleted);
  }
}

/// A mixin that simplifies working with animation graphs in a [State].
mixin AnimationGraphMixin<T extends StatefulWidget> on State<T>
    implements TickerProvider {
  /// The animation graph controller for this state.
  late final animationGraphController = AnimationGraphController(vsync: this);

  @override
  void dispose() {
    animationGraphController.dispose();
    super.dispose();
  }

  /// Starts the animation graph specified by the given [root] node.
  ///
  /// See [AnimationGraphController.animate] for more information.
  GraphAnimation animate(AnimationNode root) =>
      animationGraphController.animate(root);

  /// Cancels all running animations.
  void cancelAllAnimations() => animationGraphController.cancelAll();
}
