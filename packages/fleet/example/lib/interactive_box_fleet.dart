import 'package:fleet/fleet.dart';
import 'package:flutter/material.dart';

void main() {
  FleetBinding.ensureInitialized();
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

class _MyHomePageState extends State<MyHomePage> with AnimatingStateMixin {
  static final _distanceColorTween =
      ColorTween(begin: Colors.blue, end: Colors.green);

  var _alignment = Alignment.center;
  var _color = _distanceColorTween.begin!;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size / 2;
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) {
          setStateAsync(() {
            _alignment += Alignment(
              details.delta.dx / size.width,
              details.delta.dy / size.height,
            );
            final distance = Offset(_alignment.x, _alignment.y).distance;
            _color = _distanceColorTween.transform(distance)!;
          });
        },
        onPanEnd: (_) {
          setStateAsync(animation: Curves.ease.animation(300.ms), () {
            _alignment = Alignment.center;
            _color = _distanceColorTween.begin!;
          });
        },
        child: AAlign(
          alignment: _alignment,
          child: SizedBox.square(
            dimension: 400,
            child: AColoredBox(
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
