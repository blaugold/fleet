import 'package:flutter/widgets.dart';

import 'parameter.dart';
import 'transaction.dart';

/// A [RenderObjectWidget] that transparently animates some or all of its
/// parameters with [AnimatableParameter]s.
///
/// [T] is the type of the object that holds the [AnimatableParameter]s. Usually
/// this is a [Record] that holds the [AnimatableParameter]s as named fields.
abstract class AnimatableRenderObjectWidget<T extends Object>
    extends RenderObjectWidget {
  /// Constructor for subclasses.
  const AnimatableRenderObjectWidget({super.key});

  /// Creates the [AnimatableParameter]s for this widget.
  T createAnimatableParameters(AnimatableParameterHost host);

  /// Updates the [AnimatableParameter]s with the new values.
  ///
  /// This is called when the widget is rebuilt.
  void updateAnimatableParameters(T parameters);

  /// Updates the [RenderObject] with the current
  /// [AnimatableParameter.animatedValue]s.
  void updateRenderObjectWithAnimatableParameters(
    BuildContext context,
    covariant RenderObject renderObject,
    T parameters,
  );
}

mixin _AnimatableRenderObjectElementMixin<T extends Object>
    on RenderObjectElement, AnimatableParameterHostMixin {
  T? _animatableParameters;

  @override
  AnimatableRenderObjectWidget<T> get widget =>
      super.widget as AnimatableRenderObjectWidget<T>;

  @override
  BuildContext get context => this;

  @override
  void update(covariant RenderObjectWidget newWidget) {
    if (_animatableParameters == null) {
      if (Transaction.of(this) != null) {
        _animatableParameters = widget.createAnimatableParameters(this);
      }
    }

    super.update(newWidget);

    final animatableParameters = _animatableParameters;
    if (animatableParameters != null) {
      applyUpdateToAnimatableParameters();
      _updateRenderObjectWithAnimatableParameters();
    }
  }

  @override
  void updateAnimatableParameters() {
    widget.updateAnimatableParameters(_animatableParameters!);
  }

  @override
  void animatableParameterChanged() {
    _updateRenderObjectWithAnimatableParameters();
  }

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

  void _updateRenderObjectWithAnimatableParameters() {
    widget.updateRenderObjectWithAnimatableParameters(
      this,
      renderObject,
      _animatableParameters!,
    );
  }
}

/// A mixin that allows a [SingleChildRenderObjectWidget] to transparently
/// animate some or all of its parameters with [AnimatableParameter]s.
///
/// The widget has to implement the contract of [AnimatableRenderObjectWidget].
mixin AnimatableSingleChildRenderObjectWidgetMixin<T extends Object>
    implements AnimatableRenderObjectWidget<T> {
  @override
  SingleChildRenderObjectElement createElement() {
    return _AnimatableSingleChildRenderObjectElement(
      this as SingleChildRenderObjectWidget,
    );
  }
}

class _AnimatableSingleChildRenderObjectElement<T extends Object>
    extends SingleChildRenderObjectElement
    with AnimatableParameterHostMixin, _AnimatableRenderObjectElementMixin<T> {
  _AnimatableSingleChildRenderObjectElement(super.widget);
}
