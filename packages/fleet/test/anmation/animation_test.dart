import 'package:fleet/fleet.dart';
import 'package:fleet/src/animation/animation.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('disabled animations', () {
    testWidgets(
      'do not animate value if animations are disabled',
      (tester) async {
        debugSemanticsDisableAnimations = true;
        addTearDown(() {
          debugSemanticsDisableAnimations = false;
        });

        final host = TestHost(tester);
        final value = AnimatableDouble(0, host: host);

        await tester.withAnimation(linear1sCurve, () => value.value = 1);

        await tester.pump(d500ms);
        await tester.pumpAndSettle();

        expect(host.animationChanges, isEmpty);
      },
    );
  });

  group('set value without spec', () {
    testWidgets(
      'different value stops running animation',
      (tester) async {
        final host = TestHost(tester);
        final value = AnimatableDouble(0, host: host);

        await tester.withAnimation(linear1sCurve, () => value.value = 1);

        await tester.pump(d500ms); // .5

        expect(value.animatedValue, .5);
        value.value = 2;
        expect(value.animatedValue, 2);

        await tester.pumpAndSettle();

        expect(host.animationChanges, [.5]);
      },
    );

    testWidgets(
      'same value allows running animation to continue',
      (tester) async {
        final host = TestHost(tester);
        final value = AnimatableDouble(0, host: host);

        await tester.withAnimation(linear1sCurve, () => value.value = 1);

        await tester.pump(d500ms); // .5

        expect(value.animatedValue, .5);
        value.value = 1;
        expect(value.animatedValue, .5);

        await tester.pump(d500ms); // 1
        await tester.pumpAndSettle();

        expect(host.animationChanges, [.5, 1]);
      },
    );
  });

  group('curve', () {
    testWidgets('simple', (tester) async {
      final host = TestHost(tester);
      final value = AnimatableDouble(0, host: host);

      await tester.withAnimation(linear1sCurve, () => value.value = 1);

      await tester.pump(d500ms); // .5
      await tester.pump(d500ms); // 1
      await tester.pumpAndSettle();

      expect(host.animationChanges, [.5, 1]);
    });

    testWidgets('interrupt current animation with new one', (tester) async {
      final host = TestHost(tester);
      final value = AnimatableDouble(0, host: host);

      await tester.withAnimation(linear1sCurve, () => value.value = 1);

      await tester.pump(d500ms); // .5

      await tester.withAnimation(linear1sCurve, () => value.value = 2);

      await tester.pump(d500ms); // 1.25
      await tester.pump(d500ms); // 2
      await tester.pumpAndSettle();

      expect(host.animationChanges, [.5, 1.25, 2]);
    });

    testWidgets('delay', (tester) async {
      final host = TestHost(tester);
      final value = AnimatableDouble(0, host: host);

      await tester.withAnimation(
        linear1sCurve.delay(d500ms),
        () => value.value = 1,
      );

      await tester.pump(d500ms); // 0
      await tester.pump(d500ms); // .5
      await tester.pump(d500ms); // 1
      await tester.pumpAndSettle();

      expect(host.animationChanges, [.5, 1]);
    });

    group('speed', () {
      testWidgets('.5x', (tester) async {
        final host = TestHost(tester);
        final value = AnimatableDouble(0, host: host);

        await tester.withAnimation(
          linear1sCurve.speed(.5),
          () => value.value = 1,
        );

        await tester.pump(d500ms); // .25
        await tester.pump(d500ms); // .5
        await tester.pump(d500ms); // .75
        await tester.pump(d500ms); // 1
        await tester.pumpAndSettle();

        expect(host.animationChanges, [.25, .5, .75, 1]);
      });

      testWidgets('2x', (tester) async {
        final host = TestHost(tester);
        final value = AnimatableDouble(0, host: host);

        await tester.withAnimation(
          linear1sCurve.speed(2),
          () => value.value = 1,
        );

        await tester.pump(d250ms); // .5
        await tester.pump(d250ms); // .1
        await tester.pumpAndSettle();

        expect(host.animationChanges, [.5, 1]);
      });
    });

    group('repeat', () {
      testWidgets('2 times', (tester) async {
        final host = TestHost(tester);
        final value = AnimatableDouble(0, host: host);

        await tester.withAnimation(
          linear1sCurve.repeat(2, reverse: false),
          () => value.value = 1,
        );

        await tester.pump(d500ms); // .5
        await tester.pump(d500ms); // 1.
        await tester.pump(d500ms); // .5
        await tester.pump(d500ms); // 1
        await tester.pumpAndSettle();

        expect(host.animationChanges, [.5, 1, .5, 1]);
      });

      group('reverse', () {
        testWidgets('2 times', (tester) async {
          final host = TestHost(tester);
          final value = AnimatableDouble(0, host: host);

          await tester.withAnimation(
            linear1sCurve.repeat(2),
            () => value.value = 1,
          );

          await tester.pump(d500ms); // .5
          await tester.pump(d500ms); // 1
          await tester.pump(d500ms); // .5
          await tester.pump(d250ms); // .25
          await tester.pump(d250ms); // 1 (the last tick always goes to the end)
          await tester.pumpAndSettle();

          expect(host.animationChanges, [.5, 1, .5, .25, 1]);
        });

        testWidgets('3 times', (tester) async {
          final host = TestHost(tester);
          final value = AnimatableDouble(0, host: host);

          await tester.withAnimation(
            linear1sCurve.repeat(3),
            () => value.value = 1,
          );

          await tester.pump(d500ms); // .5
          await tester.pump(d500ms); // 1
          await tester.pump(d500ms); // .5
          await tester.pump(d500ms); // 0
          await tester.pump(d500ms); // .5
          await tester.pump(d500ms); // 1
          await tester.pumpAndSettle();

          expect(host.animationChanges, [.5, 1, .5, 0, .5, 1]);
        });
      });
    });
  });
}

const d250ms = Duration(milliseconds: 250);
const d500ms = Duration(milliseconds: 500);

final linear1sCurve = Curves.linear.animation(const Duration(seconds: 1));

extension on WidgetTester {
  Future<T> withAnimation<T>(
    AnimationSpec animationSpec,
    Block<T> block,
  ) async {
    final result = runWithAnimation(animationSpec, block);
    await pump();
    return result;
  }
}

class TestHost implements AnimatableParameterHost {
  TestHost(this.tester);

  final WidgetTester tester;
  late final AnimatableParameter<Object?> parameter;
  final animationChanges = <Object?>[];

  @override
  void registerAnimatableParameter(AnimatableParameter<Object?> parameter) {
    this.parameter = parameter;
  }

  @override
  void animatableParameterChanged() {
    animationChanges.add(parameter.animatedValue);
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    return tester.createTicker(onTick);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    throw UnimplementedError();
  }
}
