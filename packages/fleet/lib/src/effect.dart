import 'package:flutter/widgets.dart';

import 'animatable_flutter_widgets.dart';
import 'animate.dart';
import 'animation.dart';
import 'curve.dart';

// ignore: avoid_classes_with_only_static_members
/// A collection of common animation [Effect]s.
abstract class Effects {
  /// An [Effect] that fades in the widget from fully transparent to fully
  /// opaque.
  ///
  /// See also:
  ///
  /// - [Effect.opacity] for a custom opacity animation.
  static const opacity = Effect.opacity(0);

  /// An [Effect] that scales the widget from 0 to 1 in both dimensions.
  ///
  /// See also:
  ///
  /// - [Effect.scale] for a custom scale animation.
  static const scale = Effect.scale(0);

  static Effect shake({
    double magnitude = 16,
    Axis axis = Axis.horizontal,
    Duration duration = AnimationSpec.defaultDuration,
    double shakes = 1,
  }) =>
      Effect.offset(
        x: axis == Axis.horizontal ? magnitude : null,
        y: axis == Axis.vertical ? magnitude : null,
      ).animation(SineCurve(shakes).midpointMirrored.animation(duration));
}

/// A reusable and composable animation.
abstract class Effect {
  /// Const constructor for subclasses.
  const Effect();

  const factory Effect.combineAll(List<Effect> effects) = _CombinedEffect;

  const factory Effect.withAnimation(Effect effect, AnimationSpec? animation) =
      _EffectWithAnimation;

  const factory Effect.opacity(double opacity) = _OpacityEffect;

  const factory Effect.scale(
    double scale, {
    AlignmentGeometry alignment,
  }) = _ScaleEffect;

  const factory Effect.offset({double? x, double? y}) = _OffsetEffect;

  const factory Effect.offsetFrom(Offset offset) = _OffsetFromEffect;

  const factory Effect.rotate(double angle) = _RotateEffect;

  Effect get reversed => _ReversedEffect(this);

  Iterable<Effect> get _resolvedEffects sync* {
    yield this;
  }

  AnimationSpec? get _animation => null;

  Widget wrap(Widget widget, {required bool isActive});

  Effect combine(Effect other) => Effect.combineAll([this, other]);

  Effect animation(AnimationSpec? animation) =>
      Effect.withAnimation(this, animation);
}

class _EffectWithAnimation extends Effect {
  const _EffectWithAnimation(this.effect, this._animation);

  final Effect effect;

  @override
  final AnimationSpec? _animation;

  @override
  Widget wrap(Widget widget, {required bool isActive}) {
    return effect.wrap(widget, isActive: isActive);
  }

  @override
  Iterable<Effect> get _resolvedEffects sync* {
    for (final effect in effect._resolvedEffects) {
      if (effect == this.effect) {
        yield this;
      } else {
        if (effect._animation != null) {
          yield effect;
        } else {
          yield effect.animation(_animation);
        }
      }
    }
  }
}

class _CombinedEffect extends Effect {
  const _CombinedEffect(this.effects);

  final List<Effect> effects;

  @override
  Widget wrap(Widget widget, {required bool isActive}) {
    throw UnimplementedError();
  }

  @override
  Iterable<Effect> get _resolvedEffects =>
      effects.expand((effect) => effect._resolvedEffects);
}

class _ReversedEffect extends Effect {
  const _ReversedEffect(this.effect);

  final Effect effect;

  @override
  Widget wrap(Widget widget, {required bool isActive}) {
    return effect.wrap(widget, isActive: !isActive);
  }

  @override
  Iterable<Effect> get _resolvedEffects sync* {
    for (final effect in effect._resolvedEffects) {
      if (effect == this.effect) {
        yield this;
      } else {
        yield effect.reversed;
      }
    }
  }
}

class _OpacityEffect extends Effect {
  const _OpacityEffect(this.opacity);

  final double opacity;

  @override
  Widget wrap(Widget widget, {required bool isActive}) {
    return AOpacity(
      opacity: isActive ? opacity : 1.0,
      child: widget,
    );
  }
}

class _OffsetEffect extends Effect {
  const _OffsetEffect({this.x, this.y});

  final double? x;
  final double? y;

  @override
  Widget wrap(Widget widget, {required bool isActive}) {
    return ATransform.translate(
      offset: isActive ? Offset(x ?? 0, y ?? 0) : Offset.zero,
      child: widget,
    );
  }
}

class _OffsetFromEffect extends Effect {
  const _OffsetFromEffect(this.offset);

  final Offset offset;

  @override
  Widget wrap(Widget widget, {required bool isActive}) {
    return ATransform.translate(
      offset: isActive ? offset : Offset.zero,
      child: widget,
    );
  }
}

class _ScaleEffect extends Effect {
  const _ScaleEffect(this.scale, {this.alignment = Alignment.center});

  final double scale;
  final AlignmentGeometry alignment;

  @override
  Widget wrap(Widget widget, {required bool isActive}) {
    return ATransform.scale(
      scale: isActive ? scale : 1.0,
      alignment: alignment,
      child: widget,
    );
  }
}

class _RotateEffect extends Effect {
  const _RotateEffect(this.angle);

  final double angle;

  @override
  Widget wrap(Widget widget, {required bool isActive}) {
    return ATransform.rotate(
      angle: isActive ? angle : 0.0,
      child: widget,
    );
  }
}

class StateEffect extends StatefulWidget {
  const StateEffect({
    super.key,
    required this.effect,
    this.state,
    this.runOnAppearance = false,
    required this.child,
  });

  final Effect effect;

  final Object? state;

  final bool runOnAppearance;

  final Widget child;

  @override
  State<StateEffect> createState() => _EffectedState();
}

class _EffectedState extends State<StateEffect> with AnimatingStateMixin {
  Object? _state;
  var _isActive = false;

  @override
  void initState() {
    super.initState();
    _state = widget.state;
    if (widget.runOnAppearance) {
      _animate();
    }
  }

  @override
  void didUpdateWidget(covariant StateEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != _state) {
      _state = widget.state;
      _animate();
    }
  }

  void _animate() {
    _isActive = true;
    setStateAsync(animation: animationOf(context), () {
      _isActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Effected(
      effect: widget.effect,
      isActive: _isActive,
      child: widget.child,
    );
  }
}

extension EffectWidgetExtension on Widget {
  Widget appearanceEffect(Effect effect) {
    return StateEffect(
      effect: effect,
      runOnAppearance: true,
      child: this,
    );
  }

  Widget effect(Effect effect, {Object? state}) {
    return StateEffect(
      effect: effect,
      state: state,
      child: this,
    );
  }
}

class Effected extends StatefulWidget {
  const Effected({
    super.key,
    required this.effect,
    required this.isActive,
    required this.child,
  });

  final Effect effect;

  final bool isActive;

  final Widget child;

  @override
  State<Effected> createState() => _StateEffectState();
}

class _StateEffectState extends State<Effected> with AnimatingStateMixin {
  bool _isActive = false;
  var _isEffectActive = <bool>[].toList(growable: false);
  var _effects = <Effect>[].toList(growable: false);

  @override
  void initState() {
    super.initState();
    _isActive = widget.isActive;
    _updateEffects();
  }

  @override
  void didUpdateWidget(covariant Effected oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.effect != oldWidget.effect) {
      _updateEffects();
    }

    if (_isActive != widget.isActive) {
      _isActive = widget.isActive;
      if (_isActive) {
        _isEffectActive.fillRange(0, _isEffectActive.length, true);
      } else {
        _animate();
      }
    }
  }

  void _updateEffects() {
    _isEffectActive =
        List.filled(widget.effect._resolvedEffects.length, _isActive);
    _effects = widget.effect._resolvedEffects.toList(growable: false);
  }

  void _animate() {
    late final contextAnimation = animationOf(context);

    for (var index = 0; index < _effects.length; index++) {
      final animation = _effects[index]._animation ?? contextAnimation;
      if (animation != null) {
        setStateAsync(animation: animation, () {
          _isEffectActive[index] = false;
        });
      } else {
        _isEffectActive[index] = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var child = widget.child;

    for (var index = _effects.length - 1; index >= 0; index--) {
      child = _effects[index].wrap(
        child,
        isActive: _isEffectActive[index],
      );
    }

    return child;
  }
}
