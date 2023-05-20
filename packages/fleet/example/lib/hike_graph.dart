import 'package:fleet/fleet.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  var _observation = Observation.heartRate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SegmentedButton<Observation>(
              segments: const [
                ButtonSegment(
                  value: Observation.heartRate,
                  label: Text('Heart Rate'),
                ),
                ButtonSegment(
                  value: Observation.pace,
                  label: Text('Pace'),
                ),
              ],
              selected: {_observation},
              onSelectionChanged: (selection) {
                setState(() {
                  _observation = selection.single;
                });
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 400,
              height: 200,
              child: HikeGraph(
                hike: hike,
                observation: _observation,
              ),
            )
          ],
        ),
      ),
    );
  }
}

AnimationSpec ripple(int index) {
  return Curves.bounceOut.animation().delay(Duration(milliseconds: 30 * index));
}

extension on Widget {
  Widget animation(AnimationSpec animation) {
    return Animated(
      animation: animation,
      child: this,
    );
  }
}

class HikeGraph extends StatelessWidget {
  const HikeGraph({
    super.key,
    required this.hike,
    required this.observation,
  });

  final Hike hike;
  final Observation observation;

  Color get color {
    switch (observation) {
      case Observation.heartRate:
        return Colors.red;
      case Observation.pace:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = hike.observations[observation]!;
    final overallRange = data.overallRange;

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = constraints.maxWidth / 120;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < data.length; i++) ...[
              GraphCapsule(
                color: color,
                height: constraints.maxHeight,
                range: data[i],
                overallRange: overallRange,
              ).animation(ripple(i)),
              if (i < data.length - 1) SizedBox(width: spacing)
            ],
          ],
        );
      },
    );
  }
}

class GraphCapsule extends StatelessWidget {
  const GraphCapsule({
    super.key,
    required this.color,
    required this.height,
    required this.range,
    required this.overallRange,
  });

  final Color color;
  final double height;
  final Range range;
  final Range overallRange;

  @override
  Widget build(BuildContext context) {
    final relativeRange = range.relativeTo(overallRange);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AContainer(
          height: height * relativeRange.magnitude,
          width: 24,
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color: color,
          ),
        ),
        ASizedBox(
          height: height * relativeRange.min,
        )
      ],
    );
  }
}

class Range {
  Range({required this.min, required this.max});

  final double min;
  final double max;

  double get magnitude => max - min;

  Range combine(Range other) {
    return Range(
      min: min < other.min ? min : other.min,
      max: max > other.max ? max : other.max,
    );
  }

  Range relativeTo(Range other) {
    return Range(
      min: (min - other.min) / other.magnitude,
      max: (max - other.min) / other.magnitude,
    );
  }
}

extension on Iterable<Range> {
  Range get overallRange =>
      reduce((overallRange, range) => overallRange.combine(range));
}

enum Observation {
  heartRate,
  pace,
}

class Hike {
  Hike({required this.observations});

  final Map<Observation, List<Range>> observations;
}

final hike = Hike(
  observations: {
    Observation.heartRate: [
      Range(min: 10, max: 20),
      Range(min: 15, max: 25),
      Range(min: 30, max: 40),
      Range(min: 35, max: 50),
      Range(min: 40, max: 50),
      Range(min: 50, max: 60),
      Range(min: 40, max: 70),
      Range(min: 20, max: 50),
      Range(min: 25, max: 45),
      Range(min: 30, max: 40),
      Range(min: 25, max: 35),
      Range(min: 30, max: 45),
    ],
    Observation.pace: [
      Range(min: 30, max: 45),
      Range(min: 25, max: 35),
      Range(min: 30, max: 40),
      Range(min: 25, max: 45),
      Range(min: 40, max: 55),
      Range(min: 35, max: 65),
      Range(min: 50, max: 60),
      Range(min: 40, max: 50),
      Range(min: 35, max: 50),
      Range(min: 30, max: 40),
      Range(min: 15, max: 25),
      Range(min: 10, max: 20),
    ]
  },
);