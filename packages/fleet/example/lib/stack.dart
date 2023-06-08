import 'package:fleet/fleet.dart';
import 'package:fleet/modifiers.dart';
import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  runApp(const ExampleApp(page: Page()));
}

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  var _left = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _left = !_left),
        child: const Stack()([
          for (var i = 0; i < 6; i++) StackElement(index: i, left: _left),
        ]),
      ),
    );
  }
}

class StackElement extends StatelessWidget {
  const StackElement({
    super.key,
    required this.index,
    required this.left,
  });

  static const _stackDimension = 500.0;
  static const _step = 70.0;

  final int index;
  final bool left;

  AnimationSpec _buildAnimation() =>
      AnimationSpec.curve(Curves.easeInOutCubic, 500.ms - 25.ms * index)
          .delay(50.ms * index);

  Color _buildColor() =>
      HSLColor.fromAHSL(1, ((index * 12) + 155) % 360.0, 1, .5).toColor();

  @override
  Widget build(BuildContext context) {
    final elementDimension = _stackDimension - (index * _step);
    return Material(
      elevation: 50,
      color: _buildColor(),
      borderRadius: BorderRadius.circular(elementDimension / 20),
    )
        .square(elementDimension)
        .center()
        .square(_stackDimension)
        .align(Alignment(left ? -.5 : .5, 0))
        .animation(_buildAnimation(), value: left);
  }
}
