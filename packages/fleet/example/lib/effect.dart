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
  var _clicks = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _clicks++),
        child: Center(
          child: const SizedBox.square(
            dimension: 50,
            child: ColoredBox(color: Colors.blue),
          ).appearanceEffect(_effect).effect(_effect, state: _clicks),
        ),
      ),
    );
  }
}

// final _effect = const Effect.combineAll([
//   Effects.opacity,
//   Effect.offset(y: -300),
// ]).animation(Curves.bounceOut.animation(1.s));

// final _effect = const Effect.offset(y: 20)
//     .animation(const SineCurve(2).midpointMirrored.animation(250.ms));

final _effect = Effects.shake(shakes: 2);
