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

class _MyHomePageState extends State<MyHomePage> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Animated(
          animation: AnimationSpec.ease(1.s),
          value: _expanded,
          child: ASizedBox.fromSize(
            size: _expanded ? const Size.square(400) : const Size.square(200),
            child: AColoredBox(
              color: _expanded ? Colors.green : Colors.blue,
              child: Center(
                child: TextButton(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: const Text('Toggle'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
