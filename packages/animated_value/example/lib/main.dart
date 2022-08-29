import 'package:animated_value/animated_value.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide AnimatedSize;

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
    with TickerProviderStateMixin, Diagnosticable {
  late final color = AnimatedColor(Colors.blue, vsync: this);
  late final size = AnimatedSize(const Size.square(200), vsync: this);

  @override
  void dispose() {
    color.dispose();
    size.dispose();
    super.dispose();
  }

  void _animateToRed() {
    withAnimation(AnimationSpec.easeInOut(), () {
      color.value = Colors.red;
      size.value = const Size.square(250);
    });
  }

  void _animateToGreen() {
    withAnimation(
      AnimationSpec.curve(Curves.easeInOutExpo, const Duration(seconds: 1)),
      () {
        color.value = Colors.green;
        size.value = (context.findRenderObject()! as RenderBox).size;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedValueObserver(
          builder: (context, child) {
            return SizedBox.fromSize(
              size: size.animatedValue,
              child: ColoredBox(
                color: color.animatedValue,
                child: child,
              ),
            );
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: _animateToRed,
                  style: TextButton.styleFrom(primary: Colors.white),
                  child: const Text('Red'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  style: TextButton.styleFrom(primary: Colors.white),
                  onPressed: _animateToGreen,
                  child: const Text('Green'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('color', color));
    properties.add(DiagnosticsProperty('size', size));
  }
}
