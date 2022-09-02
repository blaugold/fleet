import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

/// Specification for animating visual changes.
@immutable
class AnimationSpec with Diagnosticable {
  /// Animation which uses [defaultCurve] and [defaultDuration].
  const AnimationSpec()
      : this._(
          provider: const _CurveAnimationProvider(
            curve: defaultCurve,
            duration: defaultDuration,
          ),
        );

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

  const AnimationSpec._({
    required AnimationProvider provider,
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

  final AnimationProvider _provider;
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

  /// Returns a copy of this [AnimationSpec] which will start animating after
  /// the given [delay].
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

/// The current [AnimationSpec] that will be used to animated visual changes.
AnimationSpec? get currentAnimation => _currentAnimation;
AnimationSpec? _currentAnimation;

/// Internal API of [AnimationSpec].
extension InternalAnimationSpec on AnimationSpec {
  /// The [AnimationProvider] for this [AnimationSpec].
  AnimationProvider get provider => _provider;
}

/// Runs [block] with [currentAnimation] set to [animation].
T runWithAnimation<T>(AnimationSpec animation, T Function() block) {
  final previousAnimation = _currentAnimation;
  _currentAnimation = animation;
  try {
    return block();
  } finally {
    _currentAnimation = previousAnimation;
  }
}

/// Abstraction of a value that can be animated by an [AnimationImpl].
abstract class AnimatableValue<T> implements TickerProvider {
  /// The current value of this [AnimatableValue].
  ///
  /// This value is read at the start of an animation and is animate **to**.
  T get value;

  /// The value of this [AnimatableValue] that is currently used when rendering
  /// the UI.
  ///
  /// This value is read at the start of an animation and is animate **from**.
  T get animatedValue;

  /// Returns a [Tween] that the [AnimationImpl] can use to interpolate between
  /// [value] and [animatedValue].
  ///
  /// The returned [Tween] must always evaluate to [T] even though the signature
  /// allows for a nullable type. The signature is chosen to allow the usage of
  /// [Tween]s that only return `null` when neither [Tween.begin] nor
  /// [Tween.end] are set, which [AnimationImpl] will never do.
  Tween<T?> createTween();
}

/// An object that can create [AnimationImpl]s.
///
/// See also:
///
/// - [_CurveAnimationProvider] for a provider that creates animations that uses
///   a [Curve] to animate.
abstract class AnimationProvider with Diagnosticable {
  /// Const constructor for subclasses.
  const AnimationProvider();

  /// Returns a new [AnimationImpl] to animate [value] using [animationSpec].
  ///
  /// The [previousAnimation] for [value] is provided so that the new
  /// [AnimationImpl] can decide how to transition to the new animation. For
  /// example it could blend between the previous and new animation.
  AnimationImpl<T> createAnimation<T>(
    AnimationSpec animationSpec,
    AnimatableValue<T> value,
    AnimationImpl<T>? previousAnimation,
  );
}

/// Base class for animations that animate an [AnimatableValue].
///
/// See also:
///
/// - [_CurveAnimation] for an implementation that uses a [Curve] to animate.
abstract class AnimationImpl<T> with Diagnosticable {
  /// Base constructor for subclasses.
  AnimationImpl(this._spec, this._value)
      : _tween = _value.createTween()
          ..begin = _value.animatedValue
          ..end = _value.value,
        _currentValue = _value.animatedValue {
    _ticker = _value.createTicker(_onTick);
  }

  final AnimationSpec _spec;
  final AnimatableValue<T> _value;
  final Tween<T?> _tween;
  late final Ticker _ticker;
  var _repeat = 0;
  var _forward = true;
  Duration _lastRepeatEnd = Duration.zero;
  Duration _lastRepeatDuration = Duration.zero;
  var _isStopped = false;

  /// The current value of the animation.
  T get currentValue => _currentValue;
  T _currentValue;

  /// Callback that is called when [currentValue] changes.
  VoidCallback? onChange;

  /// Callback that is called when this animation is done.
  VoidCallback? onDone;

  /// Starts this animation.
  void start() {
    assert(!_isStopped);
    assert(!_ticker.isActive);
    _ticker.start();
  }

  /// Stops this animation.
  void stop() {
    if (_isStopped) {
      return;
    }

    _isStopped = true;
    if (_ticker.isActive) {
      _ticker.stop();
    }
    _ticker.dispose();
    onDone?.call();
  }

  /// Returns a non-null value when this animation has reached its end value.
  ///
  /// [elapsed] is the time that has passed since the animation started.
  ///
  /// The returned [Duration] must be negative or zero and represents the
  /// difference between when the animation reached its end value and [elapsed].
  @protected
  Duration? isAtEnd(Duration elapsed);

  /// Returns the value of this animation at the given [elapsed] time.
  ///
  /// [elapsed] is the time that has passed since the animation started.
  ///
  /// The return type is nullable because so is that of [_tween]s, but the
  /// actually returned value must always be assignable to [T] (if [T] is
  /// nullable returning `null` is fine). See [AnimatableValue.createTween] for
  /// more information.
  @protected
  T? valueAt(Duration elapsed);

  void _onTick(Duration elapsed) {
    var elapsedForAllRepeats = elapsed * _spec._speed;

    final delay = _spec._delay;
    if (delay != null) {
      if (elapsedForAllRepeats < delay) {
        return;
      }
      elapsedForAllRepeats -= delay;
    }

    var elapsedForRepeat = elapsedForAllRepeats - _lastRepeatEnd;

    if (_forward) {
      final endDelta = isAtEnd(elapsedForRepeat);
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

    if (_isStopped) {
      // On the last tick we need to be exactly at the end of the animation.
      // If the animation is repeated and reversing it is possible that the
      // last tick is at the beginning of the animation.
      _currentValue = _tween.end as T;
    } else {
      _currentValue = valueAt(elapsedForRepeat) as T;
    }

    onChange?.call();
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
class _CurveAnimationProvider extends AnimationProvider {
  const _CurveAnimationProvider({required this.curve, required this.duration});

  final Curve curve;
  final Duration duration;

  @override
  AnimationImpl<T> createAnimation<T>(
    AnimationSpec spec,
    AnimatableValue<T> value,
    AnimationImpl<T>? previousAnimation,
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

class _CurveAnimation<T> extends AnimationImpl<T> {
  _CurveAnimation(super.spec, super.value, this._provider);

  final _CurveAnimationProvider _provider;

  @override
  Duration? isAtEnd(Duration elapsed) {
    if (elapsed >= _provider.duration) {
      return _provider.duration - elapsed;
    }
    return null;
  }

  @override
  T? valueAt(Duration elapsed) {
    var t = elapsed.inMicroseconds / _provider.duration.inMicroseconds;
    t = _provider.curve.transform(t);
    return _tween.transform(t);
  }
}
