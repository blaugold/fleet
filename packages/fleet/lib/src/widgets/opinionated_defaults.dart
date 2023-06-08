import 'package:flutter/widgets.dart';

import 'basic_flutter_widgets.dart';

class OpinionatedDefaults extends StatelessWidget {
  const OpinionatedDefaults({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child
        .defaultHorizontalMainAxisSize(MainAxisSize.min)
        .defaultVerticalMainAxisSize(MainAxisSize.min);
  }
}

extension OpinionatedDefaultsModifier on Widget {
  @widgetFactory
  Widget opinionatedDefaults() => OpinionatedDefaults(child: this);
}
