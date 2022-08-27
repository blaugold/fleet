import 'package:animated_value/animated_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('curve', () {
    testWidgets('animate once', (tester) async {
      final value = AnimatedValue<double>(0, vsync: tester);

      expect(value.value, 0);
      expect(value.animatedValue, 0);

      withAnimation(
        AnimationSpec.curve(
          curve: Curves.linear,
          duration: const Duration(seconds: 1),
        ),
        () => value.value = 1,
      );

      expect(value.value, 1);
      expect(value.animatedValue, 0);

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(value.animatedValue, .5);

      await tester.pumpAndSettle();
      expect(value.animatedValue, 1);
    });

    testWidgets('interrupt animation with new animation', (tester) async {
      final value = AnimatedValue<double>(0, vsync: tester);

      withAnimation(
        AnimationSpec.curve(
          curve: Curves.linear,
          duration: const Duration(seconds: 1),
        ),
        () => value.value = 1,
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(value.animatedValue, .5);

      // Animate animatedValue from .5 to 2 in 1 second.
      withAnimation(
        AnimationSpec.curve(
          curve: Curves.linear,
          duration: const Duration(seconds: 1),
        ),
        () => value.value = 2,
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(value.animatedValue, 1.25);

      await tester.pumpAndSettle();
      expect(value.animatedValue, 2);
    });
  });
}
