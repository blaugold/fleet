import 'package:animated_value/animated_value.dart';
import 'package:animated_value/src/animatable_widget.dart';
import 'package:animated_value/src/animation.dart';
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

        final state = TestState(tester);
        final value = AnimatableDouble(0, state: state);

        await tester.withAnimation(linear1sCurve, () => value.value = 1);

        await tester.pump(d500ms);
        await tester.pumpAndSettle();

        expect(state.history, [0, 1]);
      },
    );
  });

  group('set value without spec', () {
    testWidgets(
      'different value stops running animation',
      (tester) async {
        final state = TestState(tester);
        final value = AnimatableDouble(0, state: state);

        await tester.withAnimation(linear1sCurve, () => value.value = 1);

        await tester.pump(d500ms); // .5

        expect(value.animatedValue, .5);
        value.value = 2;
        expect(value.animatedValue, 2);

        await tester.pumpAndSettle();

        expect(state.history, [0, .5, 2]);
      },
    );

    testWidgets(
      'same value allows running animation to continue',
      (tester) async {
        final state = TestState(tester);
        final value = AnimatableDouble(0, state: state);

        await tester.withAnimation(linear1sCurve, () => value.value = 1);

        await tester.pump(d500ms); // .5

        expect(value.animatedValue, .5);
        value.value = 1;
        expect(value.animatedValue, .5);

        await tester.pump(d500ms); // 1
        await tester.pumpAndSettle();

        expect(state.history, [0, .5, 1]);
      },
    );
  });

  group('curve', () {
    testWidgets('simple', (tester) async {
      final state = TestState(tester);
      final value = AnimatableDouble(0, state: state);

      await tester.withAnimation(linear1sCurve, () => value.value = 1);

      await tester.pump(d500ms); // .5
      await tester.pump(d500ms); // 1
      await tester.pumpAndSettle();

      expect(state.history, [0, .5, 1]);
    });

    testWidgets('interrupt current animation with new one', (tester) async {
      final state = TestState(tester);
      final value = AnimatableDouble(0, state: state);

      await tester.withAnimation(linear1sCurve, () => value.value = 1);

      await tester.pump(d500ms); // .5

      await tester.withAnimation(linear1sCurve, () => value.value = 2);

      await tester.pump(d500ms); // 1.25
      await tester.pump(d500ms); // 2
      await tester.pumpAndSettle();

      expect(state.history, [0, .5, 1.25, 2]);
    });

    testWidgets('delay', (tester) async {
      final state = TestState(tester);
      final value = AnimatableDouble(0, state: state);

      await tester.withAnimation(
        linear1sCurve.delay(d500ms),
        () => value.value = 1,
      );

      await tester.pump(d500ms); // 0
      await tester.pump(d500ms); // .5
      await tester.pump(d500ms); // 1
      await tester.pumpAndSettle();

      expect(state.history, [0, .5, 1]);
    });

    group('speed', () {
      testWidgets('.5x', (tester) async {
        final state = TestState(tester);
        final value = AnimatableDouble(0, state: state);

        await tester.withAnimation(
          linear1sCurve.speed(.5),
          () => value.value = 1,
        );

        await tester.pump(d500ms); // .25
        await tester.pump(d500ms); // .5
        await tester.pump(d500ms); // .75
        await tester.pump(d500ms); // 1
        await tester.pumpAndSettle();

        expect(state.history, [0, .25, .5, .75, 1]);
      });

      testWidgets('2x', (tester) async {
        final state = TestState(tester);
        final value = AnimatableDouble(0, state: state);

        await tester.withAnimation(
          linear1sCurve.speed(2),
          () => value.value = 1,
        );

        await tester.pump(d250ms); // .5
        await tester.pump(d250ms); // .1
        await tester.pumpAndSettle();

        expect(state.history, [0, .5, 1]);
      });
    });

    group('repeat', () {
      testWidgets('2 times', (tester) async {
        final state = TestState(tester);
        final value = AnimatableDouble(0, state: state);

        await tester.withAnimation(
          linear1sCurve.repeat(2),
          () => value.value = 1,
        );

        await tester.pump(d500ms); // .5
        await tester.pump(d500ms); // 1.
        await tester.pump(d500ms); // .5
        await tester.pump(d500ms); // 1
        await tester.pumpAndSettle();

        expect(state.history, [0, .5, 1, .5, 1]);
      });

      group('reverse', () {
        testWidgets('2 times', (tester) async {
          final state = TestState(tester);
          final value = AnimatableDouble(0, state: state);

          await tester.withAnimation(
            linear1sCurve.repeat(2, reverse: true),
            () => value.value = 1,
          );

          await tester.pump(d500ms); // .5
          await tester.pump(d500ms); // 1.
          await tester.pump(d500ms); // .5
          await tester.pump(d500ms); // 0
          await tester.pumpAndSettle();

          expect(state.history, [0, .5, 1, .5, 0]);
        });

        testWidgets('3 times', (tester) async {
          final state = TestState(tester);
          final value = AnimatableDouble(0, state: state);

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

          expect(state.history, [0, .5, 1, .5, 0, .5, 1]);
        });
      });
    });
  });
}

const d250ms = Duration(milliseconds: 250);
const d500ms = Duration(milliseconds: 500);

final linear1sCurve = AnimationSpec.linear(const Duration(seconds: 1));

extension on WidgetTester {
  Future<T> withAnimation<T>(
    AnimationSpec animationSpec,
    T Function() block,
  ) async {
    final result = runWithAnimation(animationSpec, block);
    await pump();
    return result;
  }
}

class TestState implements AnimatableStateMixin {
  TestState(this.tester);

  final WidgetTester tester;
  late final AnimatableParameter<Object?> parameter;
  final history = <Object?>[];

  @override
  void registerParameter(AnimatableParameter<Object?> parameter) {
    this.parameter = parameter;
    history.add(parameter.value);
  }

  @override
  void parameterChanged() {
    history.add(parameter.animatedValue);
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
