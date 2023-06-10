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

class _PageState extends State<Page> with SingleTickerProviderStateMixin {
  static final _distanceColorTween =
      ColorTween(begin: Colors.blue, end: Colors.green);

  late final _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  final _alignmentTween = AlignmentTween(end: Alignment.center);
  final _colorTween = ColorTween(end: _distanceColorTween.begin);

  late var _alignment = _alignmentTween.end!;
  late var _color = _distanceColorTween.begin!;

  @override
  void initState() {
    super.initState();

    final curveTween = CurveTween(curve: Curves.ease);
    final alignmentAnimation =
        _alignmentTween.chain(curveTween).animate(_controller);
    final colorAnimation = _colorTween.chain(curveTween).animate(_controller);

    _controller.addListener(() {
      setState(() {
        _alignment = alignmentAnimation.value;
        _color = colorAnimation.value!;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size / 2;
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) {
          _controller.stop();
          setState(() {
            _alignment += Alignment(
              details.delta.dx / size.width,
              details.delta.dy / size.height,
            );
            final distance = Offset(_alignment.x, _alignment.y).distance;
            _color = _distanceColorTween.transform(distance)!;
          });
        },
        onPanEnd: (_) {
          _alignmentTween.begin = _alignment;
          _colorTween.begin = _color;
          _controller.forward(from: 0);
        },
        child: Align(
          alignment: _alignment,
          child: SizedBox.square(
            dimension: 400,
            child: ColoredBox(
              color: _color,
              child: const Center(
                child: Text(
                  'Drag me!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
