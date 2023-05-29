import 'package:fleet/fleet.dart';
import 'package:fleet/modifiers.dart';
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

class _MyHomePageState extends State<MyHomePage> with AnimatingStateMixin {
  static const _collapsedColor = Colors.blue;
  static const _expandedColor = Colors.green;
  static const _collapsedSize = Size.square(300);

  var _color = _collapsedColor;
  var _size = _collapsedSize;

  void _collapse() {
    setStateWithAnimation(Curves.easeInOut.animation(), () {
      _color = _collapsedColor;
      _size = _collapsedSize;
    });
  }

  void _expand() {
    setStateWithAnimation(Curves.easeInOutExpo.animation(1.s), () {
      _color = _expandedColor;
      _size = (context.findRenderObject()! as RenderBox).size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton(
            onPressed: _collapse,
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: const Text('Collapsed'),
          ),
          const SizedBox(height: 16),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            onPressed: _expand,
            child: const Text('Expanded'),
          ),
        ],
      ) //
          .center()
          .boxColor(_color)
          .sizeWith(_size)
          .center(),
    );
  }
}
