import 'package:flutter/widgets.dart';

import 'src/animation/animate.dart';
import 'src/animation/animation.dart';
import 'src/widgets/flutter/basic.dart';
import 'src/widgets/flutter/container.dart';

export 'src/widgets/flutter/basic.dart' show FleetFlexModifiers;
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
    double? y,
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    assert(() {
      _debugCheckParameterCombinations(modifier: 'alignment', [
        {'start': start},
        {'x': x}
      ]);
      _debugCheckParameterCombinations(modifier: 'alignment', [
        {'start': start, 'x': x, 'y': y},
        {'alignment': alignment}
      ]);
      return true;
    }());

    if (alignment == null) {
      if (start != null) {
        alignment = AlignmentDirectional(start, y ?? 0);
      } else {
        alignment = Alignment(x ?? 0, y ?? 0);
      }
    }

    return FleetAlign(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
    );
  }

  /// Centers this widget within the available space
  @widgetFactory
  Widget centered({double? widthFactor, double? heightFactor}) {
    return FleetCenter(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: this,
    );
  }

  /// Applies additional constraints to this widget.
  @widgetFactory
  Widget constraints({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
    BoxConstraints? constraints,
  }) {
    assert(() {
      _debugCheckParameterCombinations(modifier: 'constraints', [
        {
          'minWidth': minWidth,
          'maxWidth': maxWidth,
          'minHeight': minHeight,
          'maxHeight': maxHeight
        },
        {'constraints': constraints}
      ]);
      return true;
    }());

    constraints ??= BoxConstraints(
      minWidth: minWidth ?? 0,
      maxWidth: maxWidth ?? double.infinity,
      minHeight: minHeight ?? 0,
      maxHeight: maxHeight ?? double.infinity,
    );

    return FleetConstrainedBox(
      constraints: constraints,
      child: this,
    );
  }

  /// Applies tight size constraints to this widget.
  @widgetFactory
  Widget size({
    double? width,
    double? height,
    Size? size,
    double? square,
    bool? expand,
    bool? shrink,
    bool fractional = false,
  }) {
    assert(
      !fractional || (expand == null && shrink == null),
      'fractional cannot be used with expand or shrink',
    );
    assert(() {
      _debugCheckParameterCombinations(modifier: 'size', [
        {'width': width, 'height': height},
        {'size': size},
        {'square': square},
        {'expand': expand},
        {'shrink': shrink}
      ]);
      return true;
    }());

    if (expand ?? false) {
      return FleetSizedBox.expand(child: this);
    } else if (shrink ?? false) {
      return FleetSizedBox.shrink(child: this);
    } else {
      width ??= size?.width ?? square;
      height ??= size?.height ?? square;
      if (fractional) {
        return FleetFractionallySizedBox(
          widthFactor: width,
          heightFactor: height,
          child: this,
        );
      } else {
        return FleetSizedBox(
          width: width,
          height: height,
          child: this,
        );
      }
    }
  }

  /// Attempts to size the widget to a specific aspect ratio.
  @widgetFactory
  Widget aspectRatio(double aspectRatio) {
    return FleetAspectRatio(
      aspectRatio: aspectRatio,
      child: this,
    );
  }

  /// Adds padding around this widget.
  @widgetFactory
  Widget padding({
    double? start,
    double? end,
    double? left,
    double? right,
    double? top,
    double? bottom,
    double? horizontal,
    double? vertical,
    double? all,
    EdgeInsetsGeometry? padding,
    bool sliver = false,
  }) {
    assert(() {
      _debugCheckParameterCombinations(modifier: 'padding', [
        {'start': start, 'end': end},
        {'left': left, 'right': right},
      ]);
      _debugCheckParameterCombinations(modifier: 'padding', [
        {
          'start': start,
          'end': end,
          'left': left,
          'right': right,
          'top': top,
          'bottom': bottom
        },
        {'horizontal': horizontal, 'vertical': vertical},
        {'all': all},
        {'padding': padding}
      ]);
      return true;
    }());

    if (padding == null) {
      if (all != null) {
        padding = EdgeInsets.all(all);
      } else if (horizontal != null || vertical != null) {
        padding = EdgeInsets.symmetric(
          horizontal: horizontal ?? 0,
          vertical: vertical ?? 0,
        );
      } else if (start != null || end != null) {
        padding = EdgeInsetsDirectional.only(
          start: start ?? 0,
          end: end ?? 0,
          top: top ?? 0,
          bottom: bottom ?? 0,
        );
      } else {
        padding = EdgeInsets.only(
          left: left ?? 0,
          right: right ?? 0,
          top: top ?? 0,
          bottom: bottom ?? 0,
        );
      }
    }

    if (sliver) {
      return FleetSliverPadding(
        padding: padding,
        sliver: this,
      );
    } else {
      return FleetPadding(
        padding: padding,
        child: this,
      );
    }
  }

  /// Applies opacity to this widget.
  @widgetFactory
  Widget opacity(
    double opacity, {
    bool alwaysIncludeSemantics = false,
    bool sliver = false,
  }) {
    if (sliver) {
      return FleetSliverOpacity(
        opacity: opacity,
        alwaysIncludeSemantics: alwaysIncludeSemantics,
        sliver: this,
      );
    } else {
      return FleetOpacity(
        opacity: opacity,
        alwaysIncludeSemantics: alwaysIncludeSemantics,
        child: this,
      );
    }
  }

  /// Fills the area behind this widget with a [color].
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

  /// Offsets this widget by [x] and [y] or an [offset].
  @widgetFactory
  Widget offset({
    double? x,
    double? y,
    Offset? offset,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
    bool fractional = false,
  }) {
    assert(
      !fractional || filterQuality == null,
      'offset cannot be fractional and specify filterQuality.',
    );
    assert(() {
      _debugCheckParameterCombinations(modifier: 'offset', [
        {'x': x, 'y': y},
        {'offset': offset}
      ]);
      return true;
    }());

    offset ??= Offset(x ?? 0, y ?? 0);

    if (fractional) {
      return FleetFractionalTranslation(
        translation: offset,
        transformHitTests: transformHitTests,
        child: this,
      );
    } else {
      return FleetTransform.translate(
        offset: offset,
        transformHitTests: transformHitTests,
        filterQuality: filterQuality,
        child: this,
      );
    }
  }

  /// Scales this widget by [xy] for both the x and y axis or [x] and [y]
  /// separately.
  @widgetFactory
  Widget scale({
    double? xy,
    double? x,
    double? y,
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    assert(() {
      _debugCheckParameterCombinations(modifier: 'scale', [
        {'xy': xy},
        {'x': x, 'y': y}
      ]);
      return true;
    }());

    return FleetTransform.scale(
      scaleX: x ?? xy,
      scaleY: y ?? xy,
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

  /// Positions this widget within its parent [Stack] widget.
  @widgetFactory
  Widget position({
    double? start,
    double? end,
    double? left,
    double? right,
    double? top,
    double? bottom,
    double? height,
    double? width,
    bool? fill,
    Rect? rect,
    RelativeRect? relativeRect,
  }) {
    assert(() {
      _debugCheckParameterCombinations(modifier: 'position', [
        {'start': start, 'end': end},
        {'left': left, 'right': right},
      ]);
      _debugCheckParameterCombinations(modifier: 'position', [
        {
          'start': start,
          'end': end,
          'left': left,
          'right': right,
          'top': top,
          'bottom': bottom,
          'height': height,
          'width': width,
          'fill': fill,
        },
        {'rect': rect},
        {'relativeRect': relativeRect},
      ]);
      return true;
    }());

    if (rect != null) {
      return FleetPositioned.fromRect(
        rect: rect,
        child: this,
      );
    } else if (relativeRect != null) {
      return FleetPositioned.fromRelativeRect(
        rect: relativeRect,
        child: this,
      );
    } else {
      if (fill ?? false) {
        top ??= 0;
        bottom ??= 0;
      }

      if (start != null || end != null) {
        if (fill ?? false) {
          start ??= 0;
          end ??= 0;
        }
        return FleetPositionedDirectional(
          start: start,
          end: end,
          top: top,
          bottom: bottom,
          height: height,
          width: width,
          child: this,
        );
      } else {
        if (fill ?? false) {
          left ??= 0;
          right ??= 0;
        }
        return FleetPositioned(
          left: left,
          top: top,
          right: right,
          bottom: bottom,
          height: height,
          width: width,
          child: this,
        );
      }
    }
  }
}

/// Extension-based widget modifiers, which use Fleet's drop-in replacements for
/// [DecoratedBox].
extension DecorationModifiers on Widget {
  /// Paints a decoration either after (default) or before this widget.
  @widgetFactory
  Widget decoration({
    // Common parameters for all decorations
    Color? color,
    DecorationImage? image,
    Gradient? gradient,
    List<BoxShadow>? shadows,
    // BoxDecoration specific parameters
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    BlendMode? backgroundBlendMode,
    BoxShape? boxShape,
    // ShapeDecoration specific parameters
    ShapeBorder? shape,
    // DecoratedBox parameters
    Decoration? decoration,
    DecorationPosition position = DecorationPosition.background,
  }) {
    assert(() {
      _debugCheckParameterCombinations(modifier: 'decoration', [
        {
          'border': border,
          'borderRadius': borderRadius,
          'backgroundBlendMode': backgroundBlendMode,
          'boxShape': boxShape,
        },
        {'shape': shape}
      ]);
      return true;
    }());

    if (decoration == null) {
      if (shape != null) {
        decoration = ShapeDecoration(
          shape: shape,
          color: color,
          image: image,
          gradient: gradient,
          shadows: shadows,
        );
      } else {
        decoration = BoxDecoration(
          color: color,
          image: image,
          gradient: gradient,
          boxShadow: shadows,
          border: border,
          borderRadius: borderRadius,
          shape: boxShape ?? BoxShape.rectangle,
          backgroundBlendMode: backgroundBlendMode,
        );
      }
    }

    return FleetDecoratedBox(
      decoration: decoration,
      position: position,
      child: this,
    );
  }
}

void _debugCheckParameterCombinations(
  List<Map<String, Object?>> groups, {
  required String modifier,
}) {
  final groupsWithArguments = groups
      .map(
        (group) => group.entries
            .where((entry) => entry.value != null)
            .map((e) => e.key)
            .toList(),
      )
      .where((group) => group.isNotEmpty);

  if (groupsWithArguments.length > 1) {
    throw FlutterError.fromParts([
      ErrorSummary(
        'Invalid parameter combination for [$modifier] modifier.',
      ),
      ErrorDescription(
        'The parameters in the following groups cannot be used together:',
      ),
      for (final group in groupsWithArguments)
        ErrorDescription('  - [${group.join(', ')}]'),
    ]);
  }
}
