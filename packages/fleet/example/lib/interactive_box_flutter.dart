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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  static final _distanceColorTween =
      ColorTween(end: Colors.green, begin: Colors.blue);

  late final _controller = AnimationController(duration: 300.ms, vsync: this);

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
