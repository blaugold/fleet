import 'package:fleet/modifiers.dart';
import 'package:flutter/material.dart';

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key, required this.page});

  final Widget page;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: page,
    ) //
        .opinionatedDefaults();
  }
}
