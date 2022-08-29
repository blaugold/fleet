import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

/// Specification for animating changes of [AnimatedValue]s.
///
/// See:
///
/// - [withAnimation] for animating changes of [AnimatedValue]s.
@immutable
class AnimationSpec with Diagnosticable {
  /// Animation which uses [defaultCurve] and [defaultDuration].
  factory AnimationSpec() => AnimationSpec.curve(defaultCurve);

  /// Animation which uses the provided [curve].
  AnimationSpec.curve(Curve curve, [Duration duration = defaultDuration])
      : this._(
          provider: _CurveAnimationProvider(
            curve: curve,
            duration: duration,
          ),
        );

  /// Animation which uses [Curves.linear].
  factory AnimationSpec.linear([Duration duration = defaultDuration]) =>
      AnimationSpec.curve(Curves.linear, duration);

  /// Animation which uses [Curves.ease].
  factory AnimationSpec.ease([Duration duration = defaultDuration]) =>
      AnimationSpec.curve(Curves.ease, duration);

  /// Animation which uses [Curves.easeIn].
  factory AnimationSpec.easeIn([Duration duration = defaultDuration]) =>
      AnimationSpec.curve(Curves.easeIn, duration);

  /// Animation which uses [Curves.easeOut].
  factory AnimationSpec.easeOut([Duration duration = defaultDuration]) =>
      AnimationSpec.curve(Curves.easeOut, duration);

  /// Animation which uses [Curves.easeInOut].
  factory AnimationSpec.easeInOut([Duration duration = defaultDuration]) =>
      AnimationSpec.curve(Curves.easeInOut, duration);

  AnimationSpec._({
    required _AnimationProvider provider,
    Duration? delay,
    int? repeatCount,
    bool? reverse,
    double? speed,
  })  : _provider = provider,
        _delay = delay,
        _repeatCount = repeatCount ?? 1,
        _reverse = reverse ?? false,
        _speed = speed ?? 1;

  /// The default [Curve] used for animations, when no curve is specified.
  static const defaultCurve = Curves.linear;

  /// The default duration used for animations, when no duration is specified.
  static const defaultDuration = Duration(milliseconds: 200);

  static const _foreverRepeatCount = -1;

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

  final _AnimationProvider _provider;
  final Duration? _delay;
  final int _repeatCount;
  final bool _reverse;
  final double _speed;

  bool get _repeatForever => _repeatCount == _foreverRepeatCount;

  AnimationSpec _copyWith({
    Duration? delay,
    int? repeatCount,
    bool? reverse,
    double? speed,
  }) {
    return AnimationSpec._(
      provider: _provider,
      delay: delay ?? _delay,
      repeatCount: repeatCount ?? _repeatCount,
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
  AnimationSpec repeatForever({bool reverse = false}) =>
      _copyWith(repeatCount: _foreverRepeatCount, reverse: reverse);

  /// Returns a copy of this [AnimationSpec] with the given [speed].
  ///
  /// For example a speed of 0.5 will cause the animation to run at half speed.
  AnimationSpec speed(double speed) {
    if (speed <= 0) {
      throw ArgumentError.value(speed, 'speed', 'must be greater than zero.');
    }
    return _copyWith(speed: speed);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _provider.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Duration>(
        'delay',
        _delay,
        missingIfNull: true,
      ),
    );
    properties.add(
      DiagnosticsProperty(
        'repeat',
        _repeatForever ? 'forever' : _repeatCount,
        defaultValue: 1,
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>('reverse', _reverse, defaultValue: false),
    );
    properties.add(
      DiagnosticsProperty<double>('speed', _speed, defaultValue: 1),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimationSpec &&
          runtimeType == other.runtimeType &&
          _provider == other._provider &&
          _delay == other._delay &&
          _repeatCount == other._repeatCount &&
          _reverse == other._reverse &&
          _speed == other._speed;

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      _provider.hashCode ^
      _delay.hashCode ^
      _repeatCount.hashCode ^
      _reverse.hashCode ^
      _speed.hashCode;
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
/// withAnimation(AnimationSpec.curve(Curves.easeIn), () {
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
///
/// See:
///
/// - [AnimationSpec] for specifying how to animate changes of [AnimatedValue]s.
/// - [withAnimation] for applying an [AnimationSpec] to changes of
///   [AnimatedValue]s.
/// - [AnimatedValueObserver] for rebuilding part of the widget tree each time
///   one or more [AnimatedValue]s update their [animatedValue].
class AnimatedValue<T> extends ChangeNotifier with Diagnosticable {
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
        _vsync = vsync;

  final TweenFactory<T?> _tweenFactory;
  final TickerProvider _vsync;
  _Animation<T>? _animation;

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
    final spec = AnimationSpec.current;

    if (_value == value) {
      if (spec == null) {
        // We let any running animation continue.
        return;
      } else {
        // Start a new animation from the current _animatedValue to _value
        // with the currently active spec.
        _updateWithAnimation(spec);
      }
    } else {
      _value = value;

      if (spec == null || SemanticsBinding.instance.disableAnimations) {
        // Immediately update _animatedValue to the new _value.
        _updateWithoutAnimation();
      } else {
        // Start a new animation from the current _animatedValue to the new
        // _value with the currently active spec.
        _updateWithAnimation(spec);
      }
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
    _animation?.stop();
    super.dispose();
  }

  void _updateWithoutAnimation() {
    _animation?.stop();
    _setAnimatedValue(_value);
  }

  void _updateWithAnimation(AnimationSpec spec) {
    if (_animation == null && _value == _animatedValue) {
      return;
    }

    _animation = spec._provider.createAnimation(spec, this, _animation)
      ..start();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(DiagnosticsProperty<T>('value', value));
    properties.add(DiagnosticsProperty<T>('animatedValue', animatedValue));
    properties.add(
      DiagnosticsProperty(
        'animation',
        _animation,
        missingIfNull: true,
      ),
    );
  }
}

@immutable
abstract class _AnimationProvider with Diagnosticable {
  _Animation<T> createAnimation<T>(
    AnimationSpec spec,
    AnimatedValue<T> value,
    _Animation<T>? previousAnimation,
  );
}

abstract class _Animation<T> with Diagnosticable {
  _Animation(this._spec, this._value)
      : _tween = _value._tweenFactory()
          ..begin = _value._animatedValue
          ..end = _value._value {
    _ticker = _value._vsync.createTicker(_onTick);
  }

  final AnimationSpec _spec;
  final AnimatedValue<T> _value;
  final Tween<T?> _tween;
  late final Ticker _ticker;
  var _repeat = 0;
  var _forward = true;
  Duration _lastRepeatEnd = Duration.zero;
  Duration _lastRepeatDuration = Duration.zero;

  Tween<T?> get tween => _tween;

  void start() {
    assert(!_ticker.isActive);
    _ticker.start();
  }

  void stop() {
    if (_ticker.isActive) {
      _ticker.stop();
    }

    if (_value._animation == this) {
      _value._animation = null;
    }
  }

  Duration? isDone(Duration elapsed);

  T valueAt(Duration elapsed);

  void _onTick(Duration elapsed) {
    var elapsedForAllRepeats = elapsed;

    final delay = _spec._delay;
    if (delay != null) {
      if (elapsedForAllRepeats < delay) {
        return;
      }
      elapsedForAllRepeats -= delay;
    }

    elapsedForAllRepeats *= _spec._speed;

    var elapsedForRepeat = elapsedForAllRepeats - _lastRepeatEnd;

    if (_forward) {
      final endDelta = isDone(elapsedForRepeat);
      if (endDelta != null) {
        assert(endDelta.isNegative || endDelta.inMicroseconds == 0);
        elapsedForRepeat = elapsedForRepeat + endDelta;
        _lastRepeatEnd += elapsedForRepeat;
        _lastRepeatDuration = elapsedForRepeat;

        if (_spec._reverse) {
          _forward = false;
        }

        _onFinishRepeat();
      }
    } else {
      elapsedForRepeat = _lastRepeatDuration - elapsedForRepeat;

      if (elapsedForRepeat.isNegative || elapsedForRepeat.inMicroseconds == 0) {
        _lastRepeatEnd += _lastRepeatDuration + elapsedForRepeat;
        elapsedForRepeat = elapsedForRepeat.abs();

        _forward = true;

        _onFinishRepeat();
      }
    }

    _value._setAnimatedValue(valueAt(elapsedForRepeat));
  }

  void _onFinishRepeat() {
    if (!_spec._repeatForever && ++_repeat >= _spec._repeatCount) {
      stop();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('spec', _spec));
    properties.add(DiagnosticsProperty('repeat', _repeat));
    properties.add(DiagnosticsProperty('forward', _forward));
  }
}

@immutable
class _CurveAnimationProvider extends _AnimationProvider {
  _CurveAnimationProvider({required this.curve, required this.duration});

  final Curve curve;
  final Duration duration;

  @override
  _Animation<T> createAnimation<T>(
    AnimationSpec spec,
    AnimatedValue<T> value,
    _Animation<T>? previousAnimation,
  ) {
    previousAnimation?.stop();
    return _CurveAnimation(spec, value, this);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty('curve', curve));
    properties.add(DiagnosticsProperty<Duration>('duration', duration));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _CurveAnimationProvider &&
          runtimeType == other.runtimeType &&
          curve == other.curve &&
          duration == other.duration;

  @override
  int get hashCode => runtimeType.hashCode ^ curve.hashCode ^ duration.hashCode;
}

class _CurveAnimation<T> extends _Animation<T> {
  _CurveAnimation(super.spec, super.value, this._provider);

  final _CurveAnimationProvider _provider;

  @override
  Duration? isDone(Duration elapsed) {
    if (elapsed >= _provider.duration) {
      return _provider.duration - elapsed;
    }
    return null;
  }

  @override
  T valueAt(Duration elapsed) {
    var t = elapsed.inMicroseconds / _provider.duration.inMicroseconds;
    t = _provider.curve.transform(t);
    return tween.transform(t)!;
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
