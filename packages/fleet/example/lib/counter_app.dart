import 'package:fleet/fleet.dart';
import 'package:flutter/material.dart';

part 'counter_app.g.dart';

void main() {
  runApp(const App());
}

@view
abstract class _App extends _$App {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CounterView(),
    );
  }
}

@view
abstract class _CounterView extends _$CounterView {
  @state
  late int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('You have clicked $counter times.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter++,
        child: const Icon(Icons.add),
      ),
    );
  }
}
