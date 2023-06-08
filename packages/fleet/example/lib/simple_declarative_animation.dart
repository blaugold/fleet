import 'package:fleet/fleet.dart';
import 'package:fleet/modifiers.dart';
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

class _PageState extends State<Page> {
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
