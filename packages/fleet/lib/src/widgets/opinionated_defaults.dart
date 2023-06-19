import 'package:flutter/widgets.dart';

import 'flutter/basic.dart';

/// Applies opinionated defaults to the descendants of this widget, for
/// configurable features of Fleet.
///
/// The following defaults are applied:
///
/// | Option                          | Default            |
/// | :------------------------------ | :----------------- |
/// | [defaultHorizontalMainAxisSize] | [MainAxisSize.min] |
/// | [defaultVerticalMainAxisSize]   | [MainAxisSize.min] |
class OpinionatedDefaults extends StatelessWidget {
  /// Creates a widget that applies opinionated defaults to its descendants.
  const OpinionatedDefaults({super.key, required this.child});

  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child
        .defaultHorizontalMainAxisSize(MainAxisSize.min)
        .defaultVerticalMainAxisSize(MainAxisSize.min);
  }
}

/// Extension-based widget modifiers, related to [OpinionatedDefaults].
extension OpinionatedDefaultsModifier on Widget {
  /// Applies opinionated defaults to this widget, for configurable features of
  /// Fleet.
  ///
  /// See [OpinionatedDefaults] for the defaults that are applied.
  @widgetFactory
  Widget opinionatedDefaults() => OpinionatedDefaults(child: this);
}
