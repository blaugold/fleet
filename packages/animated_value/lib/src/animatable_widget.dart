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
/// An [AnimatableParameter] uses the [AnimationSpec] that is active when a new
/// value is set to animate the change.
///
/// By default [Tween.new] is used as a [TweenFactory] to create [Tween]s to
/// interpolate values of type [T]. See [Tween] for when a custom [Tween] is
/// needed. Also see [OptionalAnimatableParameter] for an [AnimatableParameter]
/// that handles `null` values for optional animated values.
class AnimatableParameter<T> with Diagnosticable implements AnimatableValue<T> {
  /// Creates a wrapper around an animatable parameter of a widget that supports
  /// state-based animation.
  ///
  /// It uses the provided [tweenFactory] to creates [Tween]s to interpolate
  /// between an old and a new value.
  AnimatableParameter(
    T value, {
    TweenFactory<T?>? tweenFactory,
    required AnimatableStateMixin state,
  })  : _value = value,
        _animatedValue = value,
        _tweenFactory = tweenFactory ?? Tween.new,
        _state = state {
    state.registerParameter(this);
  }

  final TweenFactory<T?> _tweenFactory;
  final AnimatableStateMixin _state;
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

/// An [AnimatableParameter] that supports `null` values.
///
/// [Tween]s returned by the provided [TweenFactory] will never be used with
/// `null` values.
///
/// When animating from `null` to a non-null value, the animation will
/// immediately jump to the non-null value.
///
/// When animating from a non-null value to `null`, the animation will
/// immediately jump to `null`.
class OptionalAnimatableParameter<T> extends AnimatableParameter<T?> {
  /// Creates an [AnimatableParameter] that supports `null` values.
  OptionalAnimatableParameter(
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

/// An [AnimatableParameter] that animates changes to an [int] through an
/// [IntTween].
class AnimatableInt extends AnimatableParameter<int> {
  /// Creates an [AnimatableParameter] that animates changes to an [int] through
  /// an [IntTween].
  AnimatableInt(super.value, {required super.state})
      : super(tweenFactory: IntTween.new);
}

/// An [AnimatableParameter] that animates changes to a [Color] through a
/// [ColorTween].
class AnimatableColor extends AnimatableParameter<Color> {
  /// Creates an [AnimatableParameter] that animates changes to a [Color]
  /// through a [ColorTween].
  AnimatableColor(super.value, {required super.state})
      : super(tweenFactory: ColorTween.new);
}

/// An [AnimatableParameter] that animates changes to a [Size] through a
/// [SizeTween].
class AnimatableSize extends AnimatableParameter<Size> {
  /// Creates an [AnimatableParameter] that animates changes to a [Size] through
  /// a [SizeTween].
  AnimatableSize(super.value, {required super.state})
      : super(tweenFactory: SizeTween.new);
}

/// An [AnimatableParameter] that animates changes to a [Rect] through a
/// [RectTween].
class AnimatableRect extends AnimatableParameter<Rect> {
  /// Creates an [AnimatableParameter] that animates changes to a [Rect] through
  /// a [RectTween].
  AnimatableRect(super.value, {required super.state})
      : super(tweenFactory: RectTween.new);
}

/// An [AnimatableParameter] that animates changes to an [AlignmentGeometry]
/// through an [AlignmentGeometryTween].
class AnimatableAlignmentGeometry
    extends AnimatableParameter<AlignmentGeometry> {
  /// Creates an [AnimatableParameter] that animates changes to an
  /// [AlignmentGeometry] through an [AlignmentGeometryTween].
  AnimatableAlignmentGeometry(super.value, {required super.state})
      : super(tweenFactory: AlignmentGeometryTween.new);
}

/// Mixin for widgets that support state-based animation of parameters.
///
/// Implementers must implement [updateAnimatableParameters] to update the
/// [AnimatableParameter]s when the widget changes and use
/// [AnimatableParameter.animatedValue] in their [build] methods.
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
///     with TickerProviderStateMixin, AnimatableStateMixin {
///   late final _dimension =
///       AnimatableParameter(widget.dimension, state: this);
///
///   @override
///   void updateAnimatableParameters() {
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
/// - [AnimatableState] for a [State] class that already mixes in
///   [AnimatableStateMixin] and [TickerProviderStateMixin].
mixin AnimatableStateMixin<T extends StatefulWidget>
    on State<T>, TickerProvider {
  final _parameters = <AnimatableParameter<void>>[];

  /// This method is called from [didUpdateWidget] and implementations must
  /// update their [AnimatableParameter]s from the new [widget] instance.
  @protected
  void updateAnimatableParameters();

  /// Registers an animatable [parameter] of the widget.
  @visibleForTesting
  void registerParameter(AnimatableParameter<void> parameter) {
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
      runWithAnimation(transaction, updateAnimatableParameters);
    } else {
      updateAnimatableParameters();
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

/// Convenience [State] base class for widgets that use [AnimatableParameter]s
/// to transparently animate their parameters.
///
/// Extend your state class from this class instead of from [State], with
/// [TickerProviderStateMixin] and [AnimatableStateMixin] mixed in.
abstract class AnimatableState<T extends StatefulWidget> extends State<T>
    with TickerProviderStateMixin, AnimatableStateMixin {}
