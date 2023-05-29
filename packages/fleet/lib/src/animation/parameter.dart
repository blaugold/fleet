import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart' hide Animation;

import 'animatable_render_object_widget.dart';
import 'animatable_widget_state.dart';
import 'animation.dart';
import 'transaction.dart';

/// A wrapper around an animatable parameter of a widget that supports animating
/// with Fleet.
///
/// [value] itself is not animated, can be changed at any time and immediately
/// reflects the new value.
///
/// [animatedValue] is animated and changes over time to the new [value].
///
/// At any given point in time there is exaclty **one** or **none**
/// [AnimationSpec]s available from the mechanism that Fleet uses to bind
/// [AnimationSpec]s to state changes.
///
/// When a new value is set, the currently available [AnimationSpec] is used to
/// animate the change.
///
/// {@category Animatable widget}
abstract class AnimatableParameter<T>
    with Diagnosticable
    implements AnimatableValue<T> {
  /// Creates a wrapper around an animatable parameter of a widget that supports
  /// animating with Fleet.
  AnimatableParameter(T value, {required AnimatableParameterHost host})
      : _value = value,
        _animatedValue = value,
        _host = host {
    host.registerAnimatableParameter(this);
  }

  final AnimatableParameterHost _host;
  AnimationImpl<T>? _animationImpl;

  /// Disposes this parameter and stops any running animation.
  void dispose() {
    _animationImpl?.stop();
  }

  /// The current animation status of this parameter, if it is animating.
  AnimationStatus? get animationStatus => _animationImpl?.status;

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
  Ticker createTicker(TickerCallback onTick) => _host.createTicker(onTick);

  void _onAnimatedValueChanged(T value) {
    if (_animatedValue != value) {
      _animatedValue = value;
      _host.animatableParameterChanged();
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
///
/// {@category Animatable widget}
class AnimatableAlignmentGeometry
    extends AnimatableParameter<AlignmentGeometry> {
  /// Creates an [AnimatableParameter] that animates changes to an
  /// [AlignmentGeometry] through an [AlignmentGeometryTween].
  AnimatableAlignmentGeometry(super.value, {required super.host});

  @override
  Tween<AlignmentGeometry?> createTween() => AlignmentGeometryTween();
}

/// Version of [AnimatableAlignmentGeometry] for optional parameters.
///
/// {@category Animatable widget}
class OptionalAnimatableAlignmentGeometry
    extends AnimatableParameter<AlignmentGeometry?> {
  /// Creates a version of [AnimatableAlignmentGeometry] for optional
  /// parameters.
  OptionalAnimatableAlignmentGeometry(super.value, {required super.host});

  @override
  Tween<AlignmentGeometry?> createTween() =>
      _OptionalTween(AlignmentGeometryTween());
}

/// An [AnimatableParameter] that animates changes to a [BoxConstraints] through
/// a [BoxConstraintsTween].
///
/// {@category Animatable widget}
class AnimatableBoxConstraints extends AnimatableParameter<BoxConstraints> {
  /// Creates an [AnimatableParameter] that animates changes to a
  /// [BoxConstraints] through a [BoxConstraintsTween].
  AnimatableBoxConstraints(super.value, {required super.host});

  @override
  Tween<BoxConstraints?> createTween() => BoxConstraintsTween();
}

/// Version of [AnimatableBoxConstraints] for optional parameters.
///
/// {@category Animatable widget}
class OptionalAnimatableBoxConstraints
    extends AnimatableParameter<BoxConstraints?> {
  /// Creates a version of [AnimatableBoxConstraints] for optional parameters.
  OptionalAnimatableBoxConstraints(super.value, {required super.host});
  @override
  Tween<BoxConstraints?> createTween() => _OptionalTween(BoxConstraintsTween());
}

/// An [AnimatableParameter] that animates changes to a [Color] through a
/// [ColorTween].
///
/// {@category Animatable widget}
class AnimatableColor extends AnimatableParameter<Color> {
  /// Creates an [AnimatableParameter] that animates changes to a [Color]
  /// through a [ColorTween].
  AnimatableColor(super.value, {required super.host});

  @override
  Tween<Color?> createTween() => ColorTween();
}

/// Version of [AnimatableColor] for optional parameters.
///
/// {@category Animatable widget}
class OptionalAnimatableColor extends AnimatableParameter<Color?> {
  /// Creates a version of [AnimatableColor] for optional parameters.
  OptionalAnimatableColor(super.value, {required super.host});

  @override
  Tween<Color?> createTween() => _OptionalTween(ColorTween());
}

/// An [AnimatableParameter] that animates changes to a [Decoration] through a
/// [DecorationTween].
///
/// {@category Animatable widget}
class AnimatableDecoration extends AnimatableParameter<Decoration> {
  /// Creates an [AnimatableParameter] that animates changes to a [Decoration]
  /// through a [DecorationTween].
  AnimatableDecoration(super.value, {required super.host});

  @override
  Tween<Decoration?> createTween() => DecorationTween();
}

/// Version of [AnimatableDecoration] for optional parameters.
///
/// {@category Animatable widget}
class OptionalAnimatableDecoration extends AnimatableParameter<Decoration?> {
  /// Creates a version of [AnimatableDecoration] for optional parameters.
  OptionalAnimatableDecoration(super.value, {required super.host});

  @override
  Tween<Decoration?> createTween() => _OptionalTween(DecorationTween());
}

/// An [AnimatableParameter] that animates changes to a [double] through a
/// [Tween].
///
/// {@category Animatable widget}
class AnimatableDouble extends AnimatableParameter<double> {
  /// Creates an [AnimatableParameter] that animates changes to a [double]
  /// through a [Tween].
  AnimatableDouble(super.value, {required super.host});

  @override
  Tween<double?> createTween() => Tween();
}

/// Version of [AnimatableDouble] for optional parameters.
///
/// {@category Animatable widget}
class OptionalAnimatableDouble extends AnimatableParameter<double?> {
  /// Creates a version of [AnimatableDouble] for optional parameters.
  OptionalAnimatableDouble(super.value, {required super.host});

  @override
  Tween<double?> createTween() => _OptionalTween(Tween());
}

/// An [AnimatableParameter] that animates changes to an [EdgeInsetsGeometry]
/// through an [EdgeInsetsGeometryTween].
///
/// {@category Animatable widget}
class AnimatableEdgeInsetsGeometry
    extends AnimatableParameter<EdgeInsetsGeometry> {
  /// Creates an [AnimatableParameter] that animates changes to an
  /// [EdgeInsetsGeometry] through an [EdgeInsetsGeometryTween].
  AnimatableEdgeInsetsGeometry(super.value, {required super.host});

  @override
  Tween<EdgeInsetsGeometry?> createTween() => EdgeInsetsGeometryTween();
}

/// Version of [AnimatableEdgeInsetsGeometry] for optional parameters.
///
/// {@category Animatable widget}
class OptionalAnimatableEdgeInsetsGeometry
    extends AnimatableParameter<EdgeInsetsGeometry?> {
  /// Creates a version of [AnimatableEdgeInsetsGeometry] for optional
  /// parameters.
  OptionalAnimatableEdgeInsetsGeometry(super.value, {required super.host});

  @override
  Tween<EdgeInsetsGeometry?> createTween() =>
      _OptionalTween(EdgeInsetsGeometryTween());
}

/// An [AnimatableParameter] that animates changes to an [int] through an
/// [IntTween].
///
/// {@category Animatable widget}
class AnimatableInt extends AnimatableParameter<int> {
  /// Creates an [AnimatableParameter] that animates changes to an [int] through
  /// an [IntTween].
  AnimatableInt(super.value, {required super.host});

  @override
  Tween<int?> createTween() => IntTween();
}

/// Version of [AnimatableInt] for optional parameters.
///
/// {@category Animatable widget}
class OptionalAnimatableInt extends AnimatableParameter<int?> {
  /// Creates a version of [AnimatableInt] that for optional parameters.
  OptionalAnimatableInt(super.value, {required super.host});

  @override
  Tween<int?> createTween() => _OptionalTween(IntTween());
}

/// An [AnimatableParameter] that animates changes to a [Matrix4] through a
/// [Matrix4Tween].
///
/// {@category Animatable widget}
class AnimatableMatrix4 extends AnimatableParameter<Matrix4> {
  /// Creates an [AnimatableParameter] that animates changes to a [Matrix4]
  /// through a [Matrix4Tween].
  AnimatableMatrix4(super.value, {required super.host});

  @override
  Tween<Matrix4?> createTween() => Matrix4Tween();
}

/// Version of [AnimatableMatrix4] for optional parameters.
///
/// {@category Animatable widget}
class OptionalAnimatableMatrix4 extends AnimatableParameter<Matrix4?> {
  /// Creates a version of [AnimatableMatrix4] for optional parameters.
  OptionalAnimatableMatrix4(super.value, {required super.host});

  @override
  Tween<Matrix4?> createTween() => _OptionalTween(Matrix4Tween());
}

/// An [AnimatableParameter] that animates changes to a value of an
/// interpolatable type [T].
///
/// See [Tween] for the requirements for a type to be interpolatable.
///
/// {@category Animatable widget}
class AnimatableObject<T> extends AnimatableParameter<T> {
  /// Creates an [AnimatableParameter] that animates changes to a value of an
  /// interpolatable type [T].
  AnimatableObject(super.value, {required super.host});

  @override
  Tween<T?> createTween() => Tween();
}

/// Version of [AnimatableObject] for optional parameters.
///
/// {@category Animatable widget}
class OptionalAnimatableObject<T> extends AnimatableParameter<T?> {
  /// Creates a version of [AnimatableObject] for optional parameters.
  OptionalAnimatableObject(super.value, {required super.host});

  @override
  Tween<T?> createTween() => _OptionalTween(Tween());
}

/// An [AnimatableParameter] that animates changes to a [Rect] through a
/// [RectTween].
///
/// {@category Animatable widget}
class AnimatableRect extends AnimatableParameter<Rect> {
  /// Creates an [AnimatableParameter] that animates changes to a [Rect] through
  /// a [RectTween].
  AnimatableRect(super.value, {required super.host});

  @override
  Tween<Rect?> createTween() => RectTween();
}

/// Version of [AnimatableRect] for optional parameters.
///
/// {@category Animatable widget}
class OptionalAnimatableRect extends AnimatableParameter<Rect?> {
  /// Creates a version of [AnimatableRect] for optional parameters.
  OptionalAnimatableRect(super.value, {required super.host});

  @override
  Tween<Rect?> createTween() => _OptionalTween(RectTween());
}

/// An [AnimatableParameter] that animates changes to a [Size] through a
/// [SizeTween].
///
/// {@category Animatable widget}
class AnimatableSize extends AnimatableParameter<Size> {
  /// Creates an [AnimatableParameter] that animates changes to a [Size] through
  /// a [SizeTween].
  AnimatableSize(super.value, {required super.host});

  @override
  Tween<Size?> createTween() => SizeTween();
}

/// Version of [AnimatableSize] for optional parameters.
///
/// {@category Animatable widget}
class OptionalAnimatableSize extends AnimatableParameter<Size?> {
  /// Creates a version of [AnimatableSize] for optional parameters.
  OptionalAnimatableSize(super.value, {required super.host});

  @override
  Tween<Size?> createTween() => _OptionalTween(SizeTween());
}

/// A host for [AnimatableParameter]s that manages the lifecycle of the
/// parameters and propagates changes to and from them.
abstract class AnimatableParameterHost implements TickerProvider {
  /// Registers an animatable [parameter] of the widget.
  void registerAnimatableParameter(AnimatableParameter<void> parameter);

  /// Notifies this [State] that one of its [AnimatableParameter]s has changed.
  void animatableParameterChanged();

  /// This method must update the hosted [AnimatableParameter]s to their new
  /// values.
  @protected
  void updateAnimatableParameters();
}

/// A mixin that implements most of the functionality of a
/// [AnimatableParameterHost].
///
/// Usually you don't need to use this mixin directly. Instead, use classes that
/// make use of it, such as [AnimatableState] and
/// [AnimatableSingleChildRenderObjectWidgetMixin].
mixin AnimatableParameterHostMixin on Diagnosticable
    implements AnimatableParameterHost {
  List<AnimatableParameter<void>>? _parameters;
  ValueNotifier<bool>? _tickerModeNotifier;
  Set<Ticker>? _tickers;

  /// Returns the [BuildContext] of where this host is located.
  @protected
  BuildContext get context;

  /// Updates the values of the hosted [AnimatableParameter]s.
  @protected
  void applyUpdateToAnimatableParameters() {
    final transaction = Transaction.of(context);
    if (transaction is AnimationSpec) {
      runWithAnimation(transaction, updateAnimatableParameters);
    } else {
      updateAnimatableParameters();
    }
  }

  /// Disposes resources managed by this mixin.
  ///
  /// Muts be called by the class that uses this mixin when it is disposed.
  @protected
  void disposeAnimatableParametersHost() {
    final parameters = _parameters;
    if (parameters != null) {
      for (final parameter in parameters) {
        parameter.dispose();
      }
    }
    _disposeTickerProvider();
  }

  /// Must be called by the class that uses this mixin when it is activated at a
  /// new location in the tree.
  @protected
  void activateAnimatableParameterHost() {
    // We may have a new TickerMode ancestor, get its Notifier.
    _updateTickerModeNotifier();
    _updateTickers();
  }

  @override
  void registerAnimatableParameter(AnimatableParameter<void> parameter) {
    final parameters = _parameters ??= <AnimatableParameter<void>>[];
    assert(!parameters.contains(parameter));
    parameters.add(parameter);
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    if (_tickerModeNotifier == null) {
      // Setup TickerMode notifier before we vend the first ticker.
      _updateTickerModeNotifier();
    }
    assert(_tickerModeNotifier != null);
    _tickers ??= <_WidgetTicker>{};
    final result = _WidgetTicker(
      onTick,
      this,
      debugLabel: kDebugMode ? 'created by ${describeIdentity(this)}' : null,
    )..muted = !_tickerModeNotifier!.value;
    _tickers!.add(result);
    return result;
  }

  void _removeTicker(_WidgetTicker ticker) {
    assert(_tickers != null);
    assert(_tickers!.contains(ticker));
    _tickers!.remove(ticker);
  }

  void _updateTickers() {
    if (_tickers != null) {
      final muted = !_tickerModeNotifier!.value;
      for (final ticker in _tickers!) {
        ticker.muted = muted;
      }
    }
  }

  void _updateTickerModeNotifier() {
    final newNotifier = TickerMode.getNotifier(context);
    if (newNotifier == _tickerModeNotifier) {
      return;
    }
    _tickerModeNotifier?.removeListener(_updateTickers);
    newNotifier.addListener(_updateTickers);
    _tickerModeNotifier = newNotifier;
  }

  void _disposeTickerProvider() {
    assert(() {
      if (_tickers != null) {
        for (final ticker in _tickers!) {
          if (ticker.isActive) {
            throw FlutterError.fromParts(<DiagnosticsNode>[
              ErrorSummary('$this was disposed with an active Ticker.'),
              ErrorDescription(
                '$runtimeType created a Ticker via its '
                'TickerProviderStateMixin, but at the time dispose() was '
                'called on the mixin, that Ticker was still active. All '
                'Tickers must be disposed before calling super.dispose().',
              ),
              ErrorHint(
                'Tickers used by AnimationControllers should be disposed by '
                'calling dispose() on the AnimationController itself. '
                'Otherwise, the ticker will leak.',
              ),
              ticker.describeForError('The offending ticker was'),
            ]);
          }
        }
      }
      return true;
    }());
    _tickerModeNotifier?.removeListener(_updateTickers);
    _tickerModeNotifier = null;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Set<Ticker>>(
        'tickers',
        _tickers,
        description: _tickers != null
            ? 'tracking ${_tickers!.length} '
                'ticker${_tickers!.length == 1 ? "" : "s"}'
            : null,
        defaultValue: null,
      ),
    );
  }
}

class _WidgetTicker extends Ticker {
  _WidgetTicker(super.onTick, this._creator, {super.debugLabel});

  final AnimatableParameterHostMixin _creator;

  @override
  void dispose() {
    _creator._removeTicker(this);
    super.dispose();
  }
}
