import 'package:flutter/widgets.dart';

import 'src/animation/animate.dart';
import 'src/animation/animation.dart';
import 'src/widgets/basic_flutter_widgets.dart';

export 'src/widgets/basic_flutter_widgets.dart' show FleetFlexModifiers;
export 'src/widgets/opinionated_defaults.dart' show OpinionatedDefaultsModifier;
export 'src/widgets/uniform_padding.dart' show UniformPaddingModifiers;

/// Extension-based widget modifiers for animating with Fleet.
extension FleetAnimationModifiers on Widget {
  /// Applies an [animation] to state changes in the descendants of this widget.
  ///
  /// See also:
  ///
  /// - [Animated] for the widget that implements this functionality.
  @widgetFactory
  Widget animation(
    AnimationSpec animation, {
    Object? value = Animated.alwaysAnimateValue,
  }) {
    return Animated(
      animation: animation,
      value: value,
      child: this,
    );
  }
}

/// Extension-based widget modifiers, which use Fleet's drop-in replacements for
/// basic Flutter widgets.
extension BasicModifiers on Widget {
  /// Aligns this widget within the available space.
  @widgetFactory
  Widget alignment({
    double? start,
    double? x,
    double y = 0,
    double? widthFactor,
    double? heightFactor,
  }) {
    assert(
      (start == null || x == null) && (start != null || x != null),
      'Exactly one of start or x must be provided.',
    );
    return alignmentFrom(
      switch (start) {
        final start? => AlignmentDirectional(start, y),
        _ => Alignment(x!, y),
      },
      widthFactor: widthFactor,
      heightFactor: heightFactor,
    );
  }

  /// Aligns this widget within the available space.
  @widgetFactory
  Widget alignmentFrom(
    AlignmentGeometry alignment, {
    double? widthFactor,
    double? heightFactor,
  }) {
    return FleetAlign(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: this,
    );
  }

  /// Centers this widget within the available space
  @widgetFactory
  Widget center({
    double? widthFactor,
    double? heightFactor,
  }) {
    return FleetCenter(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: this,
    );
  }

  /// Sizes this widget to the given [width] and [height].
  @widgetFactory
  Widget size({double? width, double? height}) {
    return FleetSizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  /// Sizes this widget to the given [Size].
  @widgetFactory
  Widget sizeFrom(Size size) {
    return FleetSizedBox.fromSize(
      size: size,
      child: this,
    );
  }

  /// Sizes this widget to a square with the given [dimension].
  @widgetFactory
  Widget squareDimension(double dimension) {
    return FleetSizedBox.square(
      dimension: dimension,
      child: this,
    );
  }

  /// Sizes this widget to become as large as its parent allows.
  @widgetFactory
  Widget maximalSize() {
    return FleetSizedBox.expand(child: this);
  }

  /// Sizes this widget to become as small as its parent allows.
  @widgetFactory
  Widget minimalSize() {
    return FleetSizedBox.shrink(child: this);
  }

  /// Adds [padding] around this widget.
  @widgetFactory
  Widget padding(EdgeInsetsGeometry padding) {
    return FleetPadding(
      padding: padding,
      child: this,
    );
  }

  /// Applies opacity to this widget.
  @widgetFactory
  Widget opacity(double opacity, {bool alwaysIncludeSemantics = false}) {
    return FleetOpacity(
      opacity: opacity,
      alwaysIncludeSemantics: alwaysIncludeSemantics,
      child: this,
    );
  }

  /// Paints the area of this widget.
  @widgetFactory
  Widget boxColor(Color color) {
    return FleetColoredBox(
      color: color,
      child: this,
    );
  }

  /// Transforms this widget using a [Matrix4].
  @widgetFactory
  Widget transform(
    Matrix4 transform, {
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return FleetTransform(
      transform: transform,
      origin: origin,
      alignment: alignment,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
      child: this,
    );
  }

  /// Rotates this widget by [angle] radians.
  @widgetFactory
  Widget rotation(
    double angle, {
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return FleetTransform.rotate(
      angle: angle,
      origin: origin,
      alignment: alignment,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
      child: this,
    );
  }

  /// Translates this widget by [x] and [y].
  @widgetFactory
  Widget offset({
    double x = 0,
    double y = 0,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return offsetFrom(
      Offset(x, y),
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
    );
  }

  /// Translates this widget by [offset].
  @widgetFactory
  Widget offsetFrom(
    Offset offset, {
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return FleetTransform.translate(
      offset: offset,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
      child: this,
    );
  }

  /// Scales this widget by [scale].
  @widgetFactory
  Widget scale(
    double scale, {
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return FleetTransform.scale(
      scale: scale,
      origin: origin,
      alignment: alignment,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
      child: this,
    );
  }

  /// Scales this widget individually along the x and y axes.
  @widgetFactory
  Widget scaleXY({
    double? x,
    double? y,
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return FleetTransform.scale(
      scaleX: x,
      scaleY: y,
      origin: origin,
      alignment: alignment,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
      child: this,
    );
  }

  /// Sizes this widget so that it fills the available space within its parent
  /// [Row], [Column], or [Flex] widget.
  @widgetFactory
  Widget expanded([int flex = 1]) {
    return this.flex(flex, fit: FlexFit.tight);
  }

  /// Sizes this widget within the constraints of the available space within its
  /// parent [Row], [Column], or [Flex] widget.
  @widgetFactory
  Widget flexible([int flex = 1]) {
    return this.flex(flex);
  }

  /// Specifies how this widget is supposed to fill the available space in the
  /// main axis within its parent [Row], [Column], or [Flex] widget.
  @widgetFactory
  Widget flex(int flex, {FlexFit fit = FlexFit.loose}) {
    return Flexible(
      flex: flex,
      fit: fit,
      child: this,
    );
  }
}
