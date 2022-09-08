import 'package:flutter/widgets.dart';

import 'animatable_flutter_widgets.dart';
import 'animate.dart';
import 'animation.dart';
import 'transaction.dart';

abstract class WidgetModifier {
  const WidgetModifier();

  Widget wrap(Widget child);
}

extension WidgetModifierExtension on Widget {
  Widget modifier(WidgetModifier modifier) => modifier.wrap(this);
}

class _CombiningModifier extends WidgetModifier {
  const _CombiningModifier(this.a, this.b);

  final WidgetModifier a;
  final WidgetModifier b;

  @override
  Widget wrap(Widget child) => a.wrap(b.wrap(child));
}

class _OpacityModifier extends WidgetModifier {
  const _OpacityModifier(this.opacity);

  final double opacity;

  @override
  Widget wrap(Widget child) => AOpacity(opacity: opacity, child: child);
}

class _OffsetModifier extends WidgetModifier {
  const _OffsetModifier(this.offset);

  final Offset offset;

  @override
  Widget wrap(Widget child) =>
      ATransform.translate(offset: offset, child: child);
}

class _ScaleModifier extends WidgetModifier {
  const _ScaleModifier(this.scale, [this.alignment]);

  final double scale;
  final AlignmentGeometry? alignment;

  @override
  Widget wrap(Widget child) => ATransform.scale(
        scale: scale,
        alignment: alignment,
        child: child,
      );
}

abstract class Transition {
  const Transition._();

  static Transition asymmetric({
    required Transition enter,
    required Transition leave,
  }) =>
      _AsymmetricTransition(enter: enter, leave: leave);

  static Transition modifier<T extends WidgetModifier>({
    required T active,
    required T identity,
  }) =>
      _ModifierTransition(active: active, identity: identity);

  static Transition offset(Offset offset) => _ModifierTransition(
        active: _OffsetModifier(offset),
        identity: const _OffsetModifier(Offset.zero),
      );

  static Transition scaleWith(double scale, [AlignmentGeometry? alignment]) =>
      _ModifierTransition(
        active: _ScaleModifier(scale, alignment),
        identity: _ScaleModifier(1, alignment),
      );

  static const opacity = _ModifierTransition(
    active: _OpacityModifier(0),
    identity: _OpacityModifier(1),
  );

  static const scale = _ModifierTransition(
    active: _ScaleModifier(0),
    identity: _ScaleModifier(1),
  );

  _TransitionHalf get _enter;
  _TransitionHalf get _leave;

  Transition combine(Transition other) => _CombiningTransition(this, other);

  Transition animation(AnimationSpec? animation) =>
      _AnimatedTransition(this, animation);
}

class _TransitionHalf<T extends WidgetModifier> {
  const _TransitionHalf({
    this.animation,
    required this.active,
    required this.identity,
  });

  final AnimationSpec? animation;
  final T active;
  final T identity;

  Widget build(Widget child, {required bool isActive}) =>
      child.modifier(isActive ? active : identity);
}

class _ModifierTransition<T extends WidgetModifier> extends Transition {
  const _ModifierTransition({
    required T active,
    required T identity,
  })  : _active = active,
        _identity = identity,
        super._();

  final T _active;
  final T _identity;

  @override
  _TransitionHalf<T> get _enter =>
      _TransitionHalf(active: _active, identity: _identity);

  @override
  _TransitionHalf<T> get _leave =>
      _TransitionHalf(active: _identity, identity: _active);
}

class _AsymmetricTransition extends Transition {
  const _AsymmetricTransition({
    required Transition enter,
    required Transition leave,
  })  : _enterTransition = enter,
        _leaveTransition = leave,
        super._();

  final Transition _enterTransition;
  final Transition _leaveTransition;

  @override
  _TransitionHalf get _enter => _enterTransition._enter;

  @override
  _TransitionHalf get _leave => _leaveTransition._leave;
}

class _CombiningTransition extends Transition {
  const _CombiningTransition(Transition a, Transition b)
      : _a = a,
        _b = b,
        super._();

  final Transition _a;
  final Transition _b;

  @override
  _TransitionHalf get _enter => _TransitionHalf(
        active: _CombiningModifier(_a._enter.active, _b._enter.active),
        identity: _CombiningModifier(_a._enter.identity, _b._enter.identity),
      );

  @override
  _TransitionHalf get _leave => _TransitionHalf(
        active: _CombiningModifier(_a._leave.active, _b._leave.active),
        identity: _CombiningModifier(_a._leave.identity, _b._leave.identity),
      );
}

class _AnimatedTransition extends Transition {
  const _AnimatedTransition(this._transition, this._animation) : super._();

  final Transition _transition;

  @override
  final AnimationSpec? _animation;

  @override
  _TransitionHalf get _enter => _TransitionHalf(
        animation: _animation,
        active: _transition._enter.active,
        identity: _transition._enter.identity,
      );

  @override
  _TransitionHalf get _leave => _TransitionHalf(
        animation: _animation,
        active: _transition._leave.active,
        identity: _transition._leave.identity,
      );
}

class Transitioner extends StatefulWidget {
  const Transitioner({
    super.key,
    this.transition = Transition.opacity,
    this.child,
  });

  final Transition transition;

  final Widget? child;

  @override
  State<Transitioner> createState() => _TransitionerState();
}

class _TransitionerState extends State<Transitioner> with AnimatingStateMixin {
  Widget? _child;
  _TransitionHalf? _transitionHalf;
  var _isActive = true;
  final _childKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _child = widget.child;
  }

  @override
  void didUpdateWidget(covariant Transitioner oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateChild(widget.child);
  }

  void _updateChild(Widget? newChild) {
    if ((_child == null) == (newChild == null)) {
      _child = newChild;
      return;
    }

    final isEntering = _child == null;

    _transitionHalf =
        isEntering ? widget.transition._enter : widget.transition._leave;

    var animation = _transitionHalf?.animation;
    if (animation == null) {
      final transaction = Transaction.of(context);
      if (transaction is AnimationSpec) {
        animation = transaction;
      }
    }

    if (animation == null) {
      _isActive = false;
      _child = newChild;
    } else {
      _isActive = true;
      if (isEntering) {
        _child = newChild;
      }

      setStateAsync(animation: animation, () {
        _isActive = false;
        // TODO: set newChild after animation finishes so that widget is actually
        //       removed
        // if (!isEntering) {
        //   _child = newChild;
        // }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var child = _child;
    if (child == null) {
      return const SizedBox();
    }

    child = KeyedSubtree(
      key: _childKey,
      child: child,
    );

    return _transitionHalf?.build(child, isActive: _isActive) ?? child;
  }
}
