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
  static const collapsedColor = Colors.blue;
  static const expandedColor = Colors.green;
  static const collapsedSize = Size.square(300);

  late final color = AnimatedColor(collapsedColor, vsync: this);
  late final size = AnimatedSize(collapsedSize, vsync: this);

  @override
  void dispose() {
    color.dispose();
    size.dispose();
    super.dispose();
  }

  void _collapse() {
    withAnimation(AnimationSpec.easeInOut(), () {
      color.value = collapsedColor;
      size.value = collapsedSize;
    });
  }

  void _expand() {
    withAnimation(
      AnimationSpec.curve(Curves.easeInOutExpo, const Duration(seconds: 1)),
      () {
        color.value = expandedColor;
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
                  onPressed: _collapse,
                  style: TextButton.styleFrom(primary: Colors.white),
                  child: const Text('Collapsed'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  style: TextButton.styleFrom(primary: Colors.white),
                  onPressed: _expand,
                  child: const Text('Expanded'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
