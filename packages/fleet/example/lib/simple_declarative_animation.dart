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

class _MyHomePageState extends State<MyHomePage> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(
        onPressed: () => setState(() => _expanded = !_expanded),
        style: TextButton.styleFrom(foregroundColor: Colors.white),
        child: const Text('Toggle'),
      )
          .uniformPadding(Edges.all, _expanded ? null : 32)
          .animation(Curves.easeInOutCubic.animation(1.s))
          .boxColor(Colors.orange)
          .center()
          .boxColor(_expanded ? Colors.green : Colors.blue)
          .sizeWith(_expanded ? const Size.square(400) : const Size.square(200))
          .animation(Curves.ease.animation(1.s))
          .center(),
    );
  }
}
