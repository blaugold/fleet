import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

/// Specification for how to animate changes to an [AnimatedValue].
///
/// See:
///
/// - [withAnimation] for animating changes to [AnimatedValue]s.
class AnimationSpec {
  /// Convenience animation which animates for 200ms and uses [Curves.ease].
  factory AnimationSpec() => AnimationSpec.curve();

  /// Animation which animates for [duration] and uses [curve].
  AnimationSpec.curve({
    Curve curve = Curves.ease,
    Duration duration = const Duration(milliseconds: 200),
  }) : this._(type: _CurveAnimation(curve: curve, duration: duration));

  AnimationSpec._({
    required _AnimationType type,
    Duration? delay,
    int? repeatCount,
    bool? repeatForever,
    bool? reverse,
    double? speed,
  })  : _type = type,
        _delay = delay,
        _repeatCount = repeatCount,
        _repeatForever = repeatForever,
        _reverse = reverse,
        _speed = speed;

  /// The current [AnimationSpec] that will be used to animated changes to
  /// [AnimatedValue]s.
  ///
  /// This value is managed by [withAnimation].
  static AnimationSpec? get current => _current;
  static AnimationSpec? _current;

  static T _runWith<T>(AnimationSpec spec, T Function() fn) {
    final previousSpec = _current;
    _current = spec;
    try {
      return fn();
    } finally {
      _current = previousSpec;
    }
  }

  final _AnimationType _type;
  final Duration? _delay;
  final int? _repeatCount;
  final bool? _repeatForever;
  final bool? _reverse;
  final double? _speed;

  AnimationSpec _copyWith({
    Duration? delay,
    int? repeatCount,
    bool? repeatForever,
    bool? reverse,
    double? speed,
  }) {
    return AnimationSpec._(
      type: _type,
      delay: delay ?? _delay,
      repeatCount: repeatCount ?? _repeatCount,
      repeatForever: repeatForever ?? _repeatForever,
      reverse: reverse ?? _reverse,
      speed: speed ?? _speed,
    );
  }

  /// Returns a copy of this [AnimationSpec] which will only start animating
  /// after the given [delay].
  AnimationSpec delay(Duration delay) => _copyWith(delay: delay);

  /// Returns a copy of this [AnimationSpec] which repeats [count] times.
  ///
  /// If [reverse] is true, the animation will reverse after finishing, instead
  /// of starting immediately from the beginning. A reverse counts as a repeat.
  AnimationSpec repeat(int count, {bool reverse = false}) {
    if (count < 0) {
      throw ArgumentError.value(count, 'count', 'must be greater than zero.');
    }
    return _copyWith(repeatCount: count, reverse: reverse);
  }

  /// Returns a copy of this [AnimationSpec] which repeats forever.
  ///
  /// If [reverse] is true, the animation will reverse after finishing, instead
  /// of starting immediately from the beginning.
  AnimationSpec repeatForever({bool reverse = false}) {
    return _copyWith(repeatForever: true, reverse: reverse);
  }

  /// Returns a copy of this [AnimationSpec] with the given [speed].
  ///
  /// For example a speed of 0.5 will cause the animation to run at half speed.
  AnimationSpec speed(double speed) {
    if (speed <= 0) {
      throw ArgumentError.value(speed, 'speed', 'must be greater than zero.');
    }
    return _copyWith(speed: speed);
  }
}

class _AnimationType {}

class _CurveAnimation extends _AnimationType {
  _CurveAnimation({required this.curve, required this.duration});
  final Curve curve;
  final Duration duration;
}

/// Runs a [block] of code and animates all changes made to [AnimatedValue]s
/// with the provided [AnimationSpec].
///
/// <!--
/// ```dart multi_begin
/// import 'package:flutter/material.dart';
///
/// late final AnimatedColor color;
/// ```
/// -->
///
/// ```dart main multi_end
/// withAnimation(AnimationSpec.curve(curve: Curves.easeIn), () {
///   color.value = Colors.blue;
/// });
/// ```
T withAnimation<T>(AnimationSpec spec, T Function() block) =>
    AnimationSpec._runWith(spec, block);

/// A function that creates a new [Tween] for values of type [T].
typedef TweenFactory<T> = Tween<T> Function();

/// A wrapper around a [value] that animates changes to that value.
///
/// [value] itself is not animated, can be changed at any time and immediately
/// reflects the new value. [animatedValue] is animated and changes over time to
/// the new [value]. [AnimatedValue] is a [ChangeNotifier] which notifies
/// listeners when [animatedValue] changes.
///
/// [AnimatedValue] requires a [TickerProvider] to drive it's animation. See
/// [TickerProviderStateMixin] and [SingleTickerProviderStateMixin] for
/// obtaining a [TickerProvider].
///
/// Don't forget to call [dispose] when you don't need a [AnimatedValue]
/// anymore, e.g. in [dispose] of a [State].
///
/// How a [value] change is animated depends on the [AnimationSpec] in
/// [AnimationSpec.current]. [AnimationSpec.current] is populated with the value
/// passed to [withAnimation]. This allows you to use the same [AnimationSpec]
/// for changes to multiple [AnimatedValue]s.
///
/// <!--
/// ```dart multi_begin
/// import 'package:flutter/material.dart' hide AnimatedSize;
///
/// late final TickerProvider vsync;
/// ```
/// -->
///
/// ```dart main multi_end
/// final color = AnimatedColor(Colors.blue, vsync: vsync);
/// final size = AnimatedSize(const Size.square(200), vsync: vsync);
///
/// withAnimation(AnimationSpec(), () {
///   color.value = Colors.red;
///   size.value = const Size.square(250);
/// });
/// ```
///
/// Changing [value] outside of [withAnimation] will not animate the change and
/// update [animatedValue] immediately.
class AnimatedValue<T> extends ChangeNotifier {
  /// Creates a wrapper around a [value] that animates changes to that value.
  ///
  /// It uses the provided [tweenFactory] to creates [Tween]s to interpolate
  /// between an old and a new value.
  ///
  /// You need to provided a [TickerProvider] in [vsync], which is used to drive
  /// the animation.
  AnimatedValue(
    T value, {
    TweenFactory<T?>? tweenFactory,
    required TickerProvider vsync,
  })  : _value = value,
        _animatedValue = value,
        _tweenFactory = tweenFactory ?? Tween.new,
        _tween = (tweenFactory ?? Tween.new)(),
        _controller = AnimationController(vsync: vsync) {
    final animation = _tween.chain(_curveTween).animate(_controller);

    // We don't need to remove the listener later because after the controller
    // is disposed, the animation will never call the listener again.
    animation.addListener(() {
      // ignore: null_check_on_nullable_type_parameter
      _setAnimatedValue(animation.value!);
    });
  }

  // ignore: unused_field
  final TweenFactory<T?> _tweenFactory;
  final Tween<T?> _tween;
  final AnimationController _controller;
  final _curveTween = CurveTween(curve: Curves.linear);
  final _animations = <_AnimationImpl<T>>[];

  /// The current, unanimated value of this property.
  ///
  /// When this property is updated outside of [withAnimation], [animatedValue]
  /// will be updated immediately.
  ///
  /// When this property is updated within [withAnimation], [animatedValue] will
  /// be animated according to the [AnimationSpec] passed to [withAnimation].
  ///
  /// Listeners of a [AnimatedValue] will **not** be notified when this value
  /// changes. They will be notified when [animatedValue] changes.
  T get value => _value;
  T _value;

  set value(T value) {
    _value = value;

    final spec = AnimationSpec.current;
    if (spec == null) {
      _updateWithoutAnimation();
    } else {
      _updateWithAnimation(spec);
    }
  }

  /// The current animated value of this property.
  ///
  /// When this property changes, a [AnimatedValue] will notify its listeners.
  ///
  /// See:
  ///
  /// - [value] for the unanimated value.
  /// - [AnimationSpec] for specifying how a change is animated.
  T get animatedValue {
    _AnimatedValueObserverState.current?._onGetProperty(this);
    return _animatedValue;
  }

  T _animatedValue;

  void _setAnimatedValue(T value) {
    if (_animatedValue != value) {
      _animatedValue = value;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _cancelAllAnimations();
    super.dispose();
  }

  void _updateWithoutAnimation() {
    _cancelAllAnimations();
    _setAnimatedValue(_value);
  }

  void _updateWithAnimation(AnimationSpec spec) {
    _cancelAllAnimations();
    _animations.add(_AnimationImpl<T>(this, spec, _value)..start());
  }

  void _cancelAllAnimations() {
    while (_animations.isNotEmpty) {
      _animations.removeLast().cancel();
    }
  }
}

class _AnimationImpl<T> {
  _AnimationImpl(this._property, this._spec, this._endValue);

  final AnimationSpec _spec;
  final AnimatedValue<T> _property;
  final T _endValue;
  Timer? _delayTimer;

  void start() {
    final spec = _spec;

    final delay = spec._delay;
    if (delay != null) {
      _delayTimer = Timer(delay, () {
        _delayTimer = null;
        _animate();
      });
      return;
    }

    _animate();
  }

  void _animate() {
    final animationType = _spec._type;
    if (animationType is _CurveAnimation) {
      var duration = animationType.duration;

      final speed = _spec._speed;
      if (speed != null) {
        duration = duration * (1 / speed);
      }

      _property._curveTween.curve = animationType.curve;
      _property._tween.begin = _property._animatedValue;
      _property._tween.end = _endValue;

      final controller = _property._controller;
      controller.duration = duration;
      controller.reset();

      if (_spec._repeatForever ?? false) {
        controller.repeat(reverse: _spec._reverse ?? false);
      } else if (_spec._repeatCount != null) {
        var remainingRepeats = _spec._repeatCount!;

        void repeat() {
          if (remainingRepeats-- <= 0) {
            return;
          }

          TickerFuture future;
          if (controller.status == AnimationStatus.dismissed) {
            future = controller.forward();
          } else {
            future = _spec._reverse ?? false
                ? controller.reverse()
                : controller.forward(from: controller.lowerBound);
          }

          future.whenComplete(repeat);
        }

        repeat();
      } else {
        controller.forward();
      }
    } else {
      throw UnimplementedError('$animationType');
    }
  }

  void cancel() {
    final delayTimer = _delayTimer;
    if (delayTimer != null) {
      delayTimer.cancel();
      _delayTimer = null;
    } else {
      _property._controller.stop();
    }
  }
}

/// An [AnimatedValue] that animates changes to an [int] through an [IntTween].
class AnimatedInt extends AnimatedValue<int> {
  /// Creates an [AnimatedValue] that animates changes to an [int] through an
  /// [IntTween].
  AnimatedInt(super.value, {required super.vsync})
      : super(tweenFactory: IntTween.new);
}

/// An [AnimatedValue] that animates changes to a [Color] through a
/// [ColorTween].
class AnimatedColor extends AnimatedValue<Color> {
  /// Creates an [AnimatedValue] that animates changes to a [Color] through a
  /// [ColorTween].
  AnimatedColor(super.value, {required super.vsync})
      : super(tweenFactory: ColorTween.new);
}

/// An [AnimatedValue] that animates changes to a [Size] through a [SizeTween].
class AnimatedSize extends AnimatedValue<Size> {
  /// Creates an [AnimatedValue] that animates changes to a [Size] through a
  /// [SizeTween].
  AnimatedSize(super.value, {required super.vsync})
      : super(tweenFactory: SizeTween.new);
}

/// An [AnimatedValue] that animates changes to a [Rect] through a [RectTween].
class AnimatedRect extends AnimatedValue<Rect> {
  /// Creates an [AnimatedValue] that animates changes to a [Rect] through a
  /// [RectTween].
  AnimatedRect(super.value, {required super.vsync})
      : super(tweenFactory: RectTween.new);
}

/// Builder for [AnimatedValueObserver].
typedef AnimatedValueObserveBuilder = Widget Function(
  BuildContext context,
  Widget? child,
);

/// A widget that observes [AnimatedValue]s and rebuilds when those
/// [AnimatedValue]'s [AnimatedValue.animatedValue] changes.
///
/// This widget records which [AnimatedValue.animatedValue]s where accessed
/// during its first build and rebuilds when any of those
/// [AnimatedValue.animatedValue]s change.
///
/// You must always access the same [AnimatedValue.animatedValue]s during each
/// build.
class AnimatedValueObserver extends StatefulWidget {
  /// Creates a widget that observes [AnimatedValue]s and rebuilds when those
  /// [AnimatedValue]'s [AnimatedValue.animatedValue] changes.
  const AnimatedValueObserver({
    super.key,
    required this.builder,
    this.child,
  });

  /// Builder that builds this widget's subtree.
  final AnimatedValueObserveBuilder builder;

  /// Optional child widget that is passed to [builder].
  ///
  /// This allows you to rebuild only a subset of the widget tree when the
  /// [AnimatedValue]s change.
  final Widget? child;

  @override
  State<AnimatedValueObserver> createState() => _AnimatedValueObserverState();
}

class _AnimatedValueObserverState extends State<AnimatedValueObserver> {
  static _AnimatedValueObserverState? current;

  bool _firstBuild = true;
  final _properties = HashSet<AnimatedValue<Object?>>.identity();

  void _onGetProperty(AnimatedValue<Object?> property) {
    if (!_properties.contains(property)) {
      _properties.add(property);
      property.addListener(_rebuild);
    }
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    for (final property in _properties) {
      property.removeListener(_rebuild);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: verify during every build that exactly the same properties are
    // accessed.
    if (_firstBuild) {
      current = this;
      try {
        return widget.builder(context, widget.child);
      } finally {
        _firstBuild = false;
        current = null;
      }
    } else {
      return widget.builder(context, widget.child);
    }
  }
}
