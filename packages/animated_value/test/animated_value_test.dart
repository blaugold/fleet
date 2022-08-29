import 'package:animated_value/animated_value.dart';
import 'package:animated_value/animated_value.dart' as av;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('curve', () {
    testWidgets('simple', (tester) async {
      final value = AnimatedValue<double>(0, vsync: tester);
      final history = valueHistory(value);

      await tester.withAnimation(linear1sCurve, () => value.value = 1);

      await tester.pump(d500ms); // .5
      await tester.pump(d500ms); // 1
      await tester.pumpAndSettle();

      expect(history, [0, .5, 1]);
    });

    testWidgets('interrupt current animation with new one', (tester) async {
      final value = AnimatedValue<double>(0, vsync: tester);
      final history = valueHistory(value);

      await tester.withAnimation(linear1sCurve, () => value.value = 1);

      await tester.pump(d500ms); // .5

      await tester.withAnimation(linear1sCurve, () => value.value = 2);

      await tester.pump(d500ms); // 1.25
      await tester.pump(d500ms); // 2
      await tester.pumpAndSettle();

      expect(history, [0, .5, 1.25, 2]);
    });

    testWidgets('delay', (tester) async {
      final value = AnimatedValue<double>(0, vsync: tester);
      final history = valueHistory(value);

      await tester.withAnimation(
        linear1sCurve.delay(d500ms),
        () => value.value = 1,
      );

      await tester.pump(d500ms); // 0
      await tester.pump(d500ms); // .5
      await tester.pump(d500ms); // 1
      await tester.pumpAndSettle();

      expect(history, [0, .5, 1]);
    });

    group('speed', () {
      testWidgets('.5x', (tester) async {
        final value = AnimatedValue<double>(0, vsync: tester);
        final history = valueHistory(value);

        await tester.withAnimation(
          linear1sCurve.speed(.5),
          () => value.value = 1,
        );

        await tester.pump(d500ms); // .25
        await tester.pump(d500ms); // .5
        await tester.pump(d500ms); // .75
        await tester.pump(d500ms); // 1
        await tester.pumpAndSettle();

        expect(history, [0, .25, .5, .75, 1]);
      });

      testWidgets('2x', (tester) async {
        final value = AnimatedValue<double>(0, vsync: tester);
        final history = valueHistory(value);

        await tester.withAnimation(
          linear1sCurve.speed(2),
          () => value.value = 1,
        );

        await tester.pump(d250ms); // .5
        await tester.pump(d250ms); // .1
        await tester.pumpAndSettle();

        expect(history, [0, .5, 1]);
      });
    });

    group('repeat', () {
      testWidgets('2 times', (tester) async {
        final value = AnimatedValue<double>(0, vsync: tester);
        final history = valueHistory(value);

        await tester.withAnimation(
          linear1sCurve.repeat(2),
          () => value.value = 1,
        );

        await tester.pump(d500ms); // .5
        await tester.pump(d500ms); // 1.
        await tester.pump(d500ms); // .5
        await tester.pump(d500ms); // 1
        await tester.pumpAndSettle();

        expect(history, [0, .5, 1, .5, 1]);
      });

      group('reverse', () {
        testWidgets('2 times', (tester) async {
          final value = AnimatedValue<double>(0, vsync: tester);
          final history = valueHistory(value);

          await tester.withAnimation(
            linear1sCurve.repeat(2, reverse: true),
            () => value.value = 1,
          );

          await tester.pump(d500ms); // .5
          await tester.pump(d500ms); // 1.
          await tester.pump(d500ms); // .5
          await tester.pump(d500ms); // 0
          await tester.pumpAndSettle();

          expect(history, [0, .5, 1, .5, 0]);
        });

        testWidgets('3 times', (tester) async {
          final value = AnimatedValue<double>(0, vsync: tester);
          final history = valueHistory(value);

          await tester.withAnimation(
            linear1sCurve.repeat(3, reverse: true),
            () => value.value = 1,
          );

          await tester.pump(d500ms); // .5
          await tester.pump(d500ms); // 1.
          await tester.pump(d500ms); // .5
          await tester.pump(d500ms); // 0
          await tester.pump(d500ms); // .5
          await tester.pump(d500ms); // 1
          await tester.pumpAndSettle();

          expect(history, [0, .5, 1, .5, 0, .5, 1]);
        });
      });
    });
  });
}

const d250ms = Duration(milliseconds: 250);
const d500ms = Duration(milliseconds: 500);

final linear1sCurve = AnimationSpec.curve(
  curve: Curves.linear,
  duration: const Duration(seconds: 1),
);

List<T> valueHistory<T>(AnimatedValue<T> value) {
  final history = <T>[value.value];
  value.addListener(() {
    history.add(value.animatedValue);
  });
  return history;
}

extension on WidgetTester {
  Future<T> withAnimation<T>(
    AnimationSpec animationSpec,
    T Function() block,
  ) async {
    final result = av.withAnimation(animationSpec, block);
    await pump();
    return result;
  }
}
