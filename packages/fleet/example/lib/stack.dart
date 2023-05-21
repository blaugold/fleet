import 'package:fleet/fleet.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _left = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _left = !_left),
        child: Stack(
          children: List.generate(
            6,
            (index) => StackElement(index: index, left: _left),
          ),
        ),
      ),
    );
  }
}

class StackElement extends StatelessWidget {
  const StackElement({super.key, required this.index, required this.left});

  final int index;
  final bool left;

  AnimationSpec _buildAnimation() {
    return AnimationSpec.curve(Curves.easeInOutCubic, 500.ms - 25.ms * index)
        .delay(50.ms * index);
  }

  Color _buildColor() =>
      HSLColor.fromAHSL(1, ((index * 12) + 155) % 360.0, 1, .5).toColor();

  @override
  Widget build(BuildContext context) {
    final dimension = 500.0 - (index * 70);
    return Material(
      elevation: 50,
      color: _buildColor(),
      borderRadius: BorderRadius.circular(dimension / 20),
    )
        .square(dimension)
        .center()
        .square(500)
        .align(Alignment(left ? -.5 : .5, 0))
        .animation(_buildAnimation(), value: left);
  }
}
