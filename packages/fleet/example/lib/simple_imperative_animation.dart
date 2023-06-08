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

class _PageState extends State<Page> with AnimatingStateMixin {
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
      body: const FleetColumn(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
      )([
        TextButton(
          onPressed: _collapse,
          style: TextButton.styleFrom(foregroundColor: Colors.white),
          child: const Text('Collapsed'),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.white),
          onPressed: _expand,
          child: const Text('Expanded'),
        ),
      ]) //
          .center()
          .boxColor(_color)
          .sizeWith(_size)
          .center(),
    );
  }
}
