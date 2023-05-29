import 'package:flutter/widgets.dart';

import 'src/animation/animate.dart';
import 'src/animation/animation.dart';
import 'src/widgets/basic_flutter_widgets.dart';

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
  Widget align(
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
    return FleetAlign(
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
  Widget sizeWith(Size size) {
    return FleetSizedBox.fromSize(
      size: size,
      child: this,
    );
  }

  /// Sizes this widget to a square with the given [dimension].
  @widgetFactory
  Widget square(double dimension) {
    return FleetSizedBox.square(
      dimension: dimension,
      child: this,
    );
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
  Widget rotate(
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

  /// Translates this widget by [offset].
  @widgetFactory
  Widget translate(
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
}
