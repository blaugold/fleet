import 'package:flutter/widgets.dart';

import 'animatable_widget.dart';

/// Animatable version of [Align].
///
/// {@category Animatable Flutter widget}
class AAlign extends StatefulWidget {
  /// Creates an animatable version of [Align].
  const AAlign({
    super.key,
    this.alignment = Alignment.center,
    this.widthFactor,
    this.heightFactor,
    this.child,
  });

  /// See [Align.alignment].
  final AlignmentGeometry alignment;

  /// See [Align.widthFactor].
  final double? widthFactor;

  /// See [Align.heightFactor].
  final double? heightFactor;

  /// See [ProxyWidget.child].
  final Widget? child;

  @override
  State<AAlign> createState() => _AAlignState();
}

class _AAlignState extends AnimatableState<AAlign> {
  late final _alignment = AnimatableAlignmentGeometry(
    widget.alignment,
    state: this,
  );
  late final _heightFactor = OptionalAnimatableDouble(
    widget.heightFactor,
    state: this,
  );
  late final _widthFactor = OptionalAnimatableDouble(
    widget.widthFactor,
    state: this,
  );

  @override
  void updateAnimatableParameters() {
    _alignment.value = widget.alignment;
    _heightFactor.value = widget.heightFactor;
    _widthFactor.value = widget.widthFactor;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _alignment.animatedValue,
      widthFactor: _widthFactor.animatedValue,
      heightFactor: _heightFactor.animatedValue,
      child: widget.child,
    );
  }
}

/// Animatable version of [ColoredBox].
///
/// {@category Animatable Flutter widget}
class AColoredBox extends StatefulWidget {
  /// Creates an animatable version of [ColoredBox].
  const AColoredBox({super.key, required this.color, this.child});

  /// See [ColoredBox.color].
  final Color color;

  /// See [ProxyWidget.child].
  final Widget? child;

  @override
  State<AColoredBox> createState() => _AColoredBoxState();
}

class _AColoredBoxState extends AnimatableState<AColoredBox> {
  late final _color = AnimatableColor(widget.color, state: this);

  @override
  void updateAnimatableParameters() {
    _color.value = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _color.animatedValue,
      child: widget.child,
    );
  }
}

/// Animatable version of [Container].
///
/// {@category Animatable Flutter widget}
class AContainer extends StatefulWidget {
  /// Creates an animatable version of [Container].
  AContainer({
    super.key,
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.margin,
    this.transform,
    this.transformAlignment,
    double? width,
    double? height,
    BoxConstraints? constraints,
    this.clipBehavior = Clip.none,
    this.child,
  }) : constraints = (width != null || height != null)
            ? constraints?.tighten(width: width, height: height) ??
                BoxConstraints.tightFor(width: width, height: height)
            : constraints;

  /// See [Container.alignment].
  final AlignmentGeometry? alignment;

  /// See [Container.padding].
  final EdgeInsetsGeometry? padding;

  /// See [Container.color].
  final Color? color;

  /// See [Container.decoration].
  final Decoration? decoration;

  /// See [Container.foregroundDecoration].
  final Decoration? foregroundDecoration;

  /// See [Container.constraints].
  final BoxConstraints? constraints;

  /// See [Container.margin].
  final EdgeInsetsGeometry? margin;

  /// See [Container.transform].
  final Matrix4? transform;

  /// See [Container.transformAlignment].
  final AlignmentGeometry? transformAlignment;

  /// See [Container.clipBehavior].
  final Clip clipBehavior;

  /// See [Container.child].
  final Widget? child;

  @override
  State<AContainer> createState() => _AContainerState();
}

class _AContainerState extends AnimatableState<AContainer> {
  late final _alignment = OptionalAnimatableAlignmentGeometry(
    widget.alignment,
    state: this,
  );
  late final _padding = OptionalAnimatableEdgeInsetsGeometry(
    widget.padding,
    state: this,
  );
  late final _color = OptionalAnimatableColor(
    widget.color,
    state: this,
  );
  late final _decoration = OptionalAnimatableDecoration(
    widget.decoration,
    state: this,
  );
  late final _foregroundDecoration = OptionalAnimatableDecoration(
    widget.foregroundDecoration,
    state: this,
  );
  late final _constraints = OptionalAnimatableBoxConstraints(
    widget.constraints,
    state: this,
  );
  late final _margin = OptionalAnimatableEdgeInsetsGeometry(
    widget.margin,
    state: this,
  );
  late final _transform = OptionalAnimatableMatrix4(
    widget.transform,
    state: this,
  );
  late final _transformAlignment = OptionalAnimatableAlignmentGeometry(
    widget.transformAlignment,
    state: this,
  );

  @override
  void updateAnimatableParameters() {
    _alignment.value = widget.alignment;
    _padding.value = widget.padding;
    _color.value = widget.color;
    _decoration.value = widget.decoration;
    _foregroundDecoration.value = widget.foregroundDecoration;
    _constraints.value = widget.constraints;
    _margin.value = widget.margin;
    _transform.value = widget.transform;
    _transformAlignment.value = widget.transformAlignment;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: _alignment.animatedValue,
      padding: _padding.animatedValue,
      color: _color.animatedValue,
      decoration: _decoration.animatedValue,
      foregroundDecoration: _foregroundDecoration.animatedValue,
      constraints: _constraints.animatedValue,
      margin: _margin.animatedValue,
      transform: _transform.animatedValue,
      transformAlignment: _transformAlignment.animatedValue,
      clipBehavior: widget.clipBehavior,
      child: widget.child,
    );
  }
}

/// Animatable version of [Opacity].
///
/// {@category Animatable Flutter widget}
class AOpacity extends StatefulWidget {
  /// Creates an animatable version of [Opacity].
  const AOpacity({
    super.key,
    required this.opacity,
    this.alwaysIncludeSemantics = false,
    this.child,
  });

  /// See [Opacity.opacity].
  final double opacity;

  /// See [Opacity.alwaysIncludeSemantics].
  final bool alwaysIncludeSemantics;

  /// See [ProxyWidget.child].
  final Widget? child;

  @override
  State<AOpacity> createState() => _AOpacityState();
}

class _AOpacityState extends AnimatableState<AOpacity> {
  late final _opacity = AnimatableDouble(widget.opacity, state: this);

  @override
  void updateAnimatableParameters() {
    _opacity.value = widget.opacity;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacity.animatedValue,
      alwaysIncludeSemantics: widget.alwaysIncludeSemantics,
      child: widget.child,
    );
  }
}

/// Animatable version of [Padding].
///
/// {@category Animatable Flutter widget}
class APadding extends StatefulWidget {
  /// Creates an animatable version of [Padding].
  const APadding({super.key, required this.padding, this.child});

  /// See [Padding.padding].
  final EdgeInsetsGeometry padding;

  /// See [ProxyWidget.child].
  final Widget? child;

  @override
  State<APadding> createState() => _APaddingState();
}

class _APaddingState extends AnimatableState<APadding> {
  late final _padding = AnimatableEdgeInsetsGeometry(
    widget.padding,
    state: this,
  );

  @override
  void updateAnimatableParameters() {
    _padding.value = widget.padding;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding.animatedValue,
      child: widget.child,
    );
  }
}

/// Animatable version of [Positioned].
///
/// {@category Animatable Flutter widget}
class APositioned extends StatefulWidget {
  /// Creates an animatable version of [Positioned].
  const APositioned({
    super.key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    required this.child,
  })  : assert(left == null || right == null || width == null),
        assert(top == null || bottom == null || height == null);

  /// See [Positioned.fromRect].
  APositioned.fromRect({
    super.key,
    required Rect rect,
    required this.child,
  })  : left = rect.left,
        top = rect.top,
        width = rect.width,
        height = rect.height,
        right = null,
        bottom = null;

  /// See [Positioned.fromRelativeRect].
  APositioned.fromRelativeRect({
    super.key,
    required RelativeRect rect,
    required this.child,
  })  : left = rect.left,
        top = rect.top,
        right = rect.right,
        bottom = rect.bottom,
        width = null,
        height = null;

  /// See [Positioned.fill].
  const APositioned.fill({
    super.key,
    this.left = 0.0,
    this.top = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
    required this.child,
  })  : width = null,
        height = null;

  /// See [Positioned.directional].
  factory APositioned.directional({
    Key? key,
    required TextDirection textDirection,
    double? start,
    double? top,
    double? end,
    double? bottom,
    double? width,
    double? height,
    required Widget child,
  }) {
    double? left;
    double? right;
    switch (textDirection) {
      case TextDirection.rtl:
        left = end;
        right = start;
        break;
      case TextDirection.ltr:
        left = start;
        right = end;
        break;
    }
    return APositioned(
      key: key,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: child,
    );
  }

  /// See [Positioned.left].
  final double? left;

  /// See [Positioned.top].
  final double? top;

  /// See [Positioned.right].
  final double? right;

  /// See [Positioned.bottom].
  final double? bottom;

  /// See [Positioned.width].
  final double? width;

  /// See [Positioned.height].
  final double? height;

  /// See [ProxyWidget.child].
  final Widget child;

  @override
  State<APositioned> createState() => _APositionedState();
}

class _APositionedState extends AnimatableState<APositioned> {
  late final _left = OptionalAnimatableDouble(widget.left, state: this);
  late final _top = OptionalAnimatableDouble(widget.top, state: this);
  late final _right = OptionalAnimatableDouble(widget.right, state: this);
  late final _bottom = OptionalAnimatableDouble(widget.bottom, state: this);
  late final _width = OptionalAnimatableDouble(widget.width, state: this);
  late final _height = OptionalAnimatableDouble(widget.height, state: this);

  @override
  void updateAnimatableParameters() {
    _left.value = widget.left;
    _top.value = widget.top;
    _right.value = widget.right;
    _bottom.value = widget.bottom;
    _width.value = widget.width;
    _height.value = widget.height;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _left.animatedValue,
      top: _top.animatedValue,
      right: _right.animatedValue,
      bottom: _bottom.animatedValue,
      width: _width.animatedValue,
      height: _height.animatedValue,
      child: widget.child,
    );
  }
}

/// Animatable version of [PositionedDirectional].
///
/// {@category Animatable Flutter widget}
class APositionedDirectional extends StatelessWidget {
  /// Creates an animatable version of [PositionedDirectional].
  const APositionedDirectional({
    super.key,
    this.start,
    this.top,
    this.end,
    this.bottom,
    this.width,
    this.height,
    required this.child,
  });

  /// See [PositionedDirectional.start].
  final double? start;

  /// See [PositionedDirectional.top].
  final double? top;

  /// See [PositionedDirectional.end].
  final double? end;

  /// See [PositionedDirectional.bottom].
  final double? bottom;

  /// See [PositionedDirectional.width].
  final double? width;

  /// See [PositionedDirectional.height].
  final double? height;

  /// See [PositionedDirectional.child].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return APositioned.directional(
      textDirection: Directionality.of(context),
      start: start,
      top: top,
      end: end,
      bottom: bottom,
      width: width,
      height: height,
      child: child,
    );
  }
}

/// Animatable version of [SizedBox].
///
/// {@category Animatable Flutter widget}
class ASizedBox extends StatefulWidget {
  /// Creates an animatable version of [SizedBox].
  const ASizedBox({
    super.key,
    required this.height,
    required this.width,
    this.child,
  });

  /// See [SizedBox.fromSize].
  ASizedBox.fromSize({super.key, this.child, Size? size})
      : height = size?.height,
        width = size?.width;

  /// See [SizedBox.square].
  const ASizedBox.square({super.key, this.child, double? dimension})
      : height = dimension,
        width = dimension;

  /// See [SizedBox.height].
  final double? height;

  /// See [SizedBox.width].
  final double? width;

  /// See [ProxyWidget.child].
  final Widget? child;

  @override
  State<ASizedBox> createState() => _ASizedBoxState();
}

class _ASizedBoxState extends AnimatableState<ASizedBox> {
  late final _height = OptionalAnimatableDouble(widget.height, state: this);
  late final _width = OptionalAnimatableDouble(widget.width, state: this);

  @override
  void updateAnimatableParameters() {
    _height.value = widget.height;
    _width.value = widget.width;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height.animatedValue,
      width: _width.animatedValue,
      child: widget.child,
    );
  }
}

/// Animatable version of [SliverOpacity].
///
/// {@category Animatable Flutter widget}
class ASliverOpacity extends StatefulWidget {
  /// Creates an animatable version of [SliverOpacity].
  const ASliverOpacity({
    super.key,
    required this.opacity,
    this.alwaysIncludeSemantics = false,
    this.sliver,
  });

  /// See [SliverOpacity.opacity].
  final double opacity;

  /// See [SliverOpacity.alwaysIncludeSemantics].
  final bool alwaysIncludeSemantics;

  /// See [ProxyWidget.child].
  final Widget? sliver;

  @override
  State<ASliverOpacity> createState() => _ASliverOpacityState();
}

class _ASliverOpacityState extends AnimatableState<ASliverOpacity> {
  late final _opacity = AnimatableDouble(widget.opacity, state: this);

  @override
  void updateAnimatableParameters() {
    _opacity.value = widget.opacity;
  }

  @override
  Widget build(BuildContext context) {
    return SliverOpacity(
      opacity: _opacity.animatedValue,
      alwaysIncludeSemantics: widget.alwaysIncludeSemantics,
      sliver: widget.sliver,
    );
  }
}

/// Animatable version of [SliverPadding].
///
/// {@category Animatable Flutter widget}
class ASliverPadding extends StatefulWidget {
  /// Creates an animatable version of [SliverPadding].
  const ASliverPadding({super.key, required this.padding, this.sliver});

  /// See [SliverPadding.padding].
  final EdgeInsetsGeometry padding;

  /// See [ProxyWidget.child].
  final Widget? sliver;

  @override
  State<ASliverPadding> createState() => _ASliverPaddingState();
}

class _ASliverPaddingState extends AnimatableState<ASliverPadding> {
  late final _padding = AnimatableEdgeInsetsGeometry(
    widget.padding,
    state: this,
  );

  @override
  void updateAnimatableParameters() {
    _padding.value = widget.padding;
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: _padding.animatedValue,
      sliver: widget.sliver,
    );
  }
}
