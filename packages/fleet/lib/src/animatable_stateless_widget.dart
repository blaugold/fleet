import 'package:flutter/widgets.dart';

import 'parameter.dart';
import 'transaction.dart';

/// A [StatelessWidget] that transparently animates some or all of its
/// parameters with [AnimatableParameter]s.
abstract class AnimatableStatelessWidget<T extends Object> extends Widget {
  /// Constructor for subclasses.
  const AnimatableStatelessWidget({super.key});

  /// Creates the [AnimatableParameter]s for this widget.
  T createAnimatableParameters(AnimatableParameterHost host);

  /// Updates the [AnimatableParameter]s with the new values.
  ///
  /// This is called when the widget is rebuilt.
  void updateAnimatableParameters(T parameters);

  /// Builds this widget with the [AnimatableParameter]s.
  ///
  /// Only if an animation has been applied will [parameters] be non-null.
  /// If [parameters] is null, the widget should be built without animation.
  /// If [parameters] is non-null, the widget should use
  /// the [AnimatableParameter.animatedValue]s.
  Widget build(BuildContext context, T? parameters);

  @override
  ComponentElement createElement() => _AnimatableStatelessElement<T>(this);
}

class _AnimatableStatelessElement<T extends Object> extends ComponentElement
    with AnimatableParameterHostMixin {
  _AnimatableStatelessElement(super.widget);

  T? _animatableParameters;

  @override
  AnimatableStatelessWidget<T> get widget =>
      super.widget as AnimatableStatelessWidget<T>;

  @override
  BuildContext get context => this;

  @override
  void update(covariant StatelessWidget newWidget) {
    var animatableParameters = _animatableParameters;
    if (animatableParameters == null) {
      if (Transaction.of(this) != null) {
        animatableParameters =
            _animatableParameters = widget.createAnimatableParameters(this);
      }
    }

    super.update(newWidget);

    if (animatableParameters != null) {
      widget.updateAnimatableParameters(animatableParameters);
    }

    rebuild(force: true);
  }

  @override
  Widget build() => widget.build(context, _animatableParameters);

  @override
  void unmount() {
    disposeAnimatableParametersHost();
    super.unmount();
  }

  @override
  void activate() {
    super.activate();
    activateAnimatableParameterHost();
  }

  @override
  void animatableParameterChanged() => markNeedsBuild();

  @override
  void updateAnimatableParameters() =>
      widget.updateAnimatableParameters(_animatableParameters!);
}
