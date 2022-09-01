import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart' hide Animation;

import 'animation.dart';
import 'transaction.dart';

/// A function that creates a new [Tween] for values of type [T].
typedef TweenFactory<T> = Tween<T> Function();

/// A wrapper around an animatable parameter of a widget that supports
/// state-based animation.
///
/// [value] itself is not animated, can be changed at any time and immediately
/// reflects the new value. [animatedValue] is animated and changes over time to
/// the new [value].
///
/// A [AnimatedParameter] uses the [AnimationSpec] that is active when a new
/// value is set to animate the change.
///
/// By default [Tween.new] is used as a [TweenFactory] to create [Tween]s to
/// interpolate values of type [T]. See [Tween] for when a custom [Tween] is
/// needed. Also see [OptionalAnimatedParameter] for an [AnimatedParameter] that
/// handles `null` values for optional animated values.
class AnimatedParameter<T> with Diagnosticable implements AnimatableValue<T> {
  /// Creates a wrapper around an animatable parameter of a widget that supports
  /// state-based animation.
  ///
  /// It uses the provided [tweenFactory] to creates [Tween]s to interpolate
  /// between an old and a new value.
  AnimatedParameter(
    T value, {
    TweenFactory<T?>? tweenFactory,
    required AnimatedWidgetStateMixin state,
  })  : _value = value,
        _animatedValue = value,
        _tweenFactory = tweenFactory ?? Tween.new,
        _state = state {
    state.registerParameter(this);
  }

  final TweenFactory<T?> _tweenFactory;
  final AnimatedWidgetStateMixin _state;
  AnimationImpl<T>? _animationImpl;

  /// Callback that is called when [animatedValue] changes.
  @visibleForTesting
  VoidCallback? onChange;

  /// Disposes this parameter and stops any running animation.
  @visibleForTesting
  void dispose() {
    _animationImpl?.stop();
  }

  @override
  T get value => _value;
  T _value;

  set value(T value) {
    final animationSpec = currentAnimation;

    if (_value != value) {
      _value = value;

      if (animationSpec == null ||
          SemanticsBinding.instance.disableAnimations) {
        // Immediately update _animatedValue to the new _value.
        _updateWithoutAnimation();
      } else {
        // Start a new animation from the current _animatedValue to the new
        // _value with the currently active spec.
        _updateWithAnimation(animationSpec);
      }
    }
  }

  @override
  T get animatedValue => _animatedValue;
  T _animatedValue;

  void _setAnimatedValue(T value) {
    if (_animatedValue != value) {
      _animatedValue = value;
      onChange?.call();
    }
  }

  @override
  Tween<T?> createTween() => _tweenFactory();

  @override
  Ticker createTicker(TickerCallback onTick) => _state.createTicker(onTick);

  void _onAnimationDone(AnimationImpl<T> animationImpl) {
    if (_animationImpl == animationImpl) {
      _animationImpl = null;
    }
  }

  void _updateWithoutAnimation() {
    _animationImpl?.stop();
    _setAnimatedValue(_value);
  }

  void _updateWithAnimation(AnimationSpec animationSpec) {
    if (_animationImpl == null && _value == _animatedValue) {
      return;
    }

    final animationImpl = animationSpec.provider
        .createAnimation(animationSpec, this, _animationImpl);

    animationImpl
      ..onChange = (() => _setAnimatedValue(animationImpl.currentValue))
      ..onDone = (() => _onAnimationDone(animationImpl))
      ..start();

    _animationImpl = animationImpl;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(DiagnosticsProperty<T>('value', value));
    properties.add(DiagnosticsProperty<T>('animatedValue', animatedValue));
    properties.add(
      DiagnosticsProperty(
        'animation',
        _animationImpl,
        missingIfNull: true,
      ),
    );
  }
}

/// An [AnimatedParameter] that supports `null` values.
///
/// [Tween]s returned by the provided [TweenFactory] will never be used with
/// `null` values.
///
/// When animating from `null` to a non-null value, the animation will
/// immediately jump to the non-null value.
///
/// When animating from a non-null value to `null`, the animation will
/// immediately jump to `null`.
class OptionalAnimatedParameter<T> extends AnimatedParameter<T?> {
  /// An [AnimatedParameter] that supports `null` values.
  OptionalAnimatedParameter(
    super.value, {
    TweenFactory<T?>? tweenFactory,
    required super.state,
  }) : super(
          tweenFactory:
              _optionalValueTweenFactory<T?>(tweenFactory ?? Tween.new),
        );
}

TweenFactory<T?> _optionalValueTweenFactory<T>(TweenFactory<T> factory) =>
    () => _OptionalValueTween(factory());

class _OptionalValueTween<T> extends Tween<T?> {
  _OptionalValueTween(this._inner);

  final Tween<T?> _inner;

  @override
  T? get begin => _inner.begin;

  @override
  set begin(T? value) => _inner.begin = value;

  @override
  T? get end => _inner.end;

  @override
  set end(T? value) => _inner.end = value;

  @override
  T? transform(double t) {
    if (begin == null) {
      return end;
    }
    if (end == null) {
      return null;
    }
    return _inner.transform(t);
  }
}

/// An [AnimatedParameter] that animates changes to an [int] through an
/// [IntTween].
class AnimatedInt extends AnimatedParameter<int> {
  /// Creates an [AnimatedParameter] that animates changes to an [int] through
  /// an [IntTween].
  AnimatedInt(super.value, {required super.state})
      : super(tweenFactory: IntTween.new);
}

/// An [AnimatedParameter] that animates changes to a [Color] through a
/// [ColorTween].
class AnimatedColor extends AnimatedParameter<Color> {
  /// Creates an [AnimatedParameter] that animates changes to a [Color] through
  /// a [ColorTween].
  AnimatedColor(super.value, {required super.state})
      : super(tweenFactory: ColorTween.new);
}

/// An [AnimatedParameter] that animates changes to a [Size] through a
/// [SizeTween].
class AnimatedSize extends AnimatedParameter<Size> {
  /// Creates an [AnimatedParameter] that animates changes to a [Size] through a
  /// [SizeTween].
  AnimatedSize(super.value, {required super.state})
      : super(tweenFactory: SizeTween.new);
}

/// An [AnimatedParameter] that animates changes to a [Rect] through a
/// [RectTween].
class AnimatedRect extends AnimatedParameter<Rect> {
  /// Creates an [AnimatedParameter] that animates changes to a [Rect] through a
  /// [RectTween].
  AnimatedRect(super.value, {required super.state})
      : super(tweenFactory: RectTween.new);
}

/// An [AnimatedParameter] that animates changes to an [AlignmentGeometry]
/// through an [AlignmentGeometryTween].
class AnimatedAlignmentGeometry extends AnimatedParameter<AlignmentGeometry> {
  /// Creates an [AnimatedParameter] that animates changes to an
  /// [AlignmentGeometry] through an [AlignmentGeometryTween].
  AnimatedAlignmentGeometry(super.value, {required super.state})
      : super(tweenFactory: AlignmentGeometryTween.new);
}

/// Mixin for widgets that support state-based animation of parameters.
///
/// Implementers must implement [updateAnimatedValues] to update the
/// [AnimatedParameter]s when the widget changes and use
/// [AnimatedParameter.animatedValue] in their [build] methods.
///
/// ```dart
/// import 'package:flutter/widgets.dart';
///
/// class Square extends StatefulWidget {
///   Square({super.key, required this.dimension, required this.child});
///
///   final double dimension;
///   final Widget child;
///
///   @override
///   _SquareState createState() => _SquareState();
/// }
///
/// class _SquareState extends State<Square>
///     with TickerProviderStateMixin, AnimatedWidgetStateMixin {
///   late final _dimension = AnimatedParameter(widget.dimension, state: this);
///
///   @override
///   void updateAnimatedValues() {
///     _dimension.value = widget.dimension;
///   }
///
///   @protected
///   Widget build(BuildContext context) {
///     return SizedBox.square(
///       dimension: _dimension.animatedValue,
///       child: widget.child,
///     );
///   }
/// }
/// ```
///
/// See also:
///
/// - [AnimatedWidgetState] for a [State] class that already mixes in
///   [AnimatedWidgetStateMixin] and [TickerProviderStateMixin].
mixin AnimatedWidgetStateMixin<T extends StatefulWidget>
    on State<T>, TickerProvider {
  final _parameters = <AnimatedParameter<void>>[];

  /// This method is called from [didUpdateWidget] and implementations must
  /// update their [AnimatedParameter]s from the new [widget] instance.
  @protected
  void updateAnimatedValues();

  /// Registers an animatable [parameter] of the widget.
  @visibleForTesting
  void registerParameter(AnimatedParameter<void> parameter) {
    assert(!_parameters.contains(parameter));
    assert(parameter.onChange == null);
    _parameters.add(parameter);
    parameter.onChange = _update;
  }

  @protected
  void _update() => setState(() {});

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);

    final transaction = Transaction.of(context);
    if (transaction is AnimationSpec) {
      runWithAnimation(transaction, updateAnimatedValues);
    } else {
      updateAnimatedValues();
    }
  }

  @override
  void dispose() {
    for (final parameter in _parameters) {
      parameter.dispose();
    }
    super.dispose();
  }
}

/// Convenience [State] base class for widgets that use [AnimatedParameter]s to
/// transparently animate parameters.
///
/// Extend your state class from this class instead of from [State], with
/// [TickerProviderStateMixin] and [AnimatedWidgetStateMixin] mixed in.
abstract class AnimatedWidgetState<T extends StatefulWidget> extends State<T>
    with TickerProviderStateMixin, AnimatedWidgetStateMixin {}
