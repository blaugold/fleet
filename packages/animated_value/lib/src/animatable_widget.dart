import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart' hide Animation;

import 'animation.dart';
import 'transaction.dart';

/// A wrapper around an animatable parameter of a widget that supports
/// state-based animation.
///
/// [value] itself is not animated, can be changed at any time and immediately
/// reflects the new value. [animatedValue] is animated and changes over time to
/// the new [value].
///
/// An [AnimatableParameter] uses the [AnimationSpec] that is active when a new
/// value is set to animate the change.
abstract class AnimatableParameter<T>
    with Diagnosticable
    implements AnimatableValue<T> {
  /// Creates a wrapper around an animatable parameter of a widget that supports
  /// state-based animation.
  AnimatableParameter(T value, {required AnimatableStateMixin state})
      : _value = value,
        _animatedValue = value,
        _state = state {
    state.registerParameter(this);
  }

  final AnimatableStateMixin _state;
  AnimationImpl<T>? _animationImpl;

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

  @override
  Ticker createTicker(TickerCallback onTick) => _state.createTicker(onTick);

  void _onAnimatedValueChanged(T value) {
    if (_animatedValue != value) {
      _animatedValue = value;
      _state.parameterChanged();
    }
  }

  void _onAnimationDone(AnimationImpl<T> animationImpl) {
    if (_animationImpl == animationImpl) {
      _animationImpl = null;
    }
  }

  void _updateWithoutAnimation() {
    _animationImpl?.stop();
    // We don't need to notify _state because this only happens when
    // the state is rebuilding anyway.
    _animatedValue = _value;
  }

  void _updateWithAnimation(AnimationSpec animationSpec) {
    if (_animationImpl == null && _value == _animatedValue) {
      // There is no difference between _value and _animatedValue that we can
      // interpolate, so there is no point in starting an animation.
      //
      // If another animation is currently running we allow the new
      // animation to decide how to proceed.
      return;
    }

    final animationImpl = animationSpec.provider
        .createAnimation(animationSpec, this, _animationImpl);

    animationImpl
      ..onChange = (() => _onAnimatedValueChanged(animationImpl.currentValue))
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

class _OptionalTween<T> extends Tween<T?> {
  _OptionalTween(this._inner);

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

/// An [AnimatableParameter] that animates changes to an [AlignmentGeometry]
/// through an [AlignmentGeometryTween].
class AnimatableAlignmentGeometry
    extends AnimatableParameter<AlignmentGeometry> {
  /// Creates an [AnimatableParameter] that animates changes to an
  /// [AlignmentGeometry] through an [AlignmentGeometryTween].
  AnimatableAlignmentGeometry(super.value, {required super.state});

  @override
  Tween<AlignmentGeometry?> createTween() => AlignmentGeometryTween();
}

/// Version of [AnimatableAlignmentGeometry] for optional parameters.
class OptionalAnimatableAlignmentGeometry
    extends AnimatableParameter<AlignmentGeometry?> {
  /// Creates a version of [AnimatableAlignmentGeometry] for optional
  /// parameters.
  OptionalAnimatableAlignmentGeometry(super.value, {required super.state});

  @override
  Tween<AlignmentGeometry?> createTween() =>
      _OptionalTween(AlignmentGeometryTween());
}

/// An [AnimatableParameter] that animates changes to a [BoxConstraints] through
/// a [BoxConstraintsTween].
class AnimatableBoxConstraints extends AnimatableParameter<BoxConstraints> {
  /// Creates an [AnimatableParameter] that animates changes to a
  /// [BoxConstraints] through a [BoxConstraintsTween].
  AnimatableBoxConstraints(super.value, {required super.state});

  @override
  Tween<BoxConstraints?> createTween() => BoxConstraintsTween();
}

/// Version of [AnimatableBoxConstraints] for optional parameters.
class OptionalAnimatableBoxConstraints
    extends AnimatableParameter<BoxConstraints?> {
  /// Creates a version of [AnimatableBoxConstraints] for optional parameters.
  OptionalAnimatableBoxConstraints(super.value, {required super.state});
  @override
  Tween<BoxConstraints?> createTween() => _OptionalTween(BoxConstraintsTween());
}

/// An [AnimatableParameter] that animates changes to a [Color] through a
/// [ColorTween].
class AnimatableColor extends AnimatableParameter<Color> {
  /// Creates an [AnimatableParameter] that animates changes to a [Color]
  /// through a [ColorTween].
  AnimatableColor(super.value, {required super.state});

  @override
  Tween<Color?> createTween() => ColorTween();
}

/// Version of [AnimatableColor] for optional parameters.
class OptionalAnimatableColor extends AnimatableParameter<Color?> {
  /// Creates a version of [AnimatableColor] for optional parameters.
  OptionalAnimatableColor(super.value, {required super.state});

  @override
  Tween<Color?> createTween() => _OptionalTween(ColorTween());
}

/// An [AnimatableParameter] that animates changes to a [Decoration] through a
/// [DecorationTween].
class AnimatableDecoration extends AnimatableParameter<Decoration> {
  /// Creates an [AnimatableParameter] that animates changes to a [Decoration]
  /// through a [DecorationTween].
  AnimatableDecoration(super.value, {required super.state});

  @override
  Tween<Decoration?> createTween() => DecorationTween();
}

/// Version of [AnimatableDecoration] for optional parameters.
class OptionalAnimatableDecoration extends AnimatableParameter<Decoration?> {
  /// Creates a version of [AnimatableDecoration] for optional parameters.
  OptionalAnimatableDecoration(super.value, {required super.state});

  @override
  Tween<Decoration?> createTween() => _OptionalTween(DecorationTween());
}

/// An [AnimatableParameter] that animates changes to a [double] through a
/// [Tween].
class AnimatableDouble extends AnimatableParameter<double> {
  /// Creates an [AnimatableParameter] that animates changes to a [double]
  /// through a [Tween].
  AnimatableDouble(super.value, {required super.state});

  @override
  Tween<double?> createTween() => Tween();
}

/// Version of [AnimatableDouble] for optional parameters.
class OptionalAnimatableDouble extends AnimatableParameter<double?> {
  /// Creates a version of [AnimatableDouble] for optional parameters.
  OptionalAnimatableDouble(super.value, {required super.state});

  @override
  Tween<double?> createTween() => _OptionalTween(Tween());
}

/// An [AnimatableParameter] that animates changes to an [EdgeInsetsGeometry]
/// through an [EdgeInsetsGeometryTween].
class AnimatableEdgeInsetsGeometry
    extends AnimatableParameter<EdgeInsetsGeometry> {
  /// Creates an [AnimatableParameter] that animates changes to an
  /// [EdgeInsetsGeometry] through an [EdgeInsetsGeometryTween].
  AnimatableEdgeInsetsGeometry(super.value, {required super.state});

  @override
  Tween<EdgeInsetsGeometry?> createTween() => EdgeInsetsGeometryTween();
}

/// Version of [AnimatableEdgeInsetsGeometry] for optional parameters.
class OptionalAnimatableEdgeInsetsGeometry
    extends AnimatableParameter<EdgeInsetsGeometry?> {
  /// Creates a version of [AnimatableEdgeInsetsGeometry] for optional
  /// parameters.
  OptionalAnimatableEdgeInsetsGeometry(super.value, {required super.state});

  @override
  Tween<EdgeInsetsGeometry?> createTween() =>
      _OptionalTween(EdgeInsetsGeometryTween());
}

/// An [AnimatableParameter] that animates changes to an [int] through an
/// [IntTween].
class AnimatableInt extends AnimatableParameter<int> {
  /// Creates an [AnimatableParameter] that animates changes to an [int] through
  /// an [IntTween].
  AnimatableInt(super.value, {required super.state});

  @override
  Tween<int?> createTween() => IntTween();
}

/// Version of [AnimatableInt] for optional parameters.
class OptionalAnimatableInt extends AnimatableParameter<int?> {
  /// Creates a version of [AnimatableInt] that for optional parameters.
  OptionalAnimatableInt(super.value, {required super.state});

  @override
  Tween<int?> createTween() => _OptionalTween(IntTween());
}

/// An [AnimatableParameter] that animates changes to a [Matrix4] through a
/// [Matrix4Tween].
class AnimatableMatrix4 extends AnimatableParameter<Matrix4> {
  /// Creates an [AnimatableParameter] that animates changes to a [Matrix4]
  /// through a [Matrix4Tween].
  AnimatableMatrix4(super.value, {required super.state});

  @override
  Tween<Matrix4?> createTween() => Matrix4Tween();
}

/// Version of [AnimatableMatrix4] for optional parameters.
class OptionalAnimatableMatrix4 extends AnimatableParameter<Matrix4?> {
  /// Creates a version of [AnimatableMatrix4] for optional parameters.
  OptionalAnimatableMatrix4(super.value, {required super.state});

  @override
  Tween<Matrix4?> createTween() => _OptionalTween(Matrix4Tween());
}

/// An [AnimatableParameter] that animates changes to a [Rect] through a
/// [RectTween].
class AnimatableRect extends AnimatableParameter<Rect> {
  /// Creates an [AnimatableParameter] that animates changes to a [Rect] through
  /// a [RectTween].
  AnimatableRect(super.value, {required super.state});

  @override
  Tween<Rect?> createTween() => RectTween();
}

/// Version of [AnimatableRect] for optional parameters.
class OptionalAnimatableRect extends AnimatableParameter<Rect?> {
  /// Creates a version of [AnimatableRect] for optional parameters.
  OptionalAnimatableRect(super.value, {required super.state});

  @override
  Tween<Rect?> createTween() => _OptionalTween(RectTween());
}

/// An [AnimatableParameter] that animates changes to a [Size] through a
/// [SizeTween].
class AnimatableSize extends AnimatableParameter<Size> {
  /// Creates an [AnimatableParameter] that animates changes to a [Size] through
  /// a [SizeTween].
  AnimatableSize(super.value, {required super.state});

  @override
  Tween<Size?> createTween() => SizeTween();
}

/// Version of [AnimatableSize] for optional parameters.
class OptionalAnimatableSize extends AnimatableParameter<Size?> {
  /// Creates a version of [AnimatableSize] for optional parameters.
  OptionalAnimatableSize(super.value, {required super.state});

  @override
  Tween<Size?> createTween() => _OptionalTween(SizeTween());
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
///       AnimatableDouble(widget.dimension, state: this);
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
    _parameters.add(parameter);
  }

  /// Notifies this [State] that one of its [AnimatableParameter]s has changed.
  @protected
  @visibleForTesting
  void parameterChanged() => setState(() {});

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
