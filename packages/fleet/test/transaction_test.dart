import 'package:fleet/src/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('intermediate building', () {
    testWidgets('rebuild dirty elements', (tester) async {
      final state = ValueNotifier(0);
      ValueKey<int> key() => ValueKey(state.value);

      await tester.pumpWidget(
        ValueListenableBuilder<int>(
          valueListenable: state,
          builder: (context, value, _) {
            return SizedBox(key: ValueKey(value));
          },
        ),
      );

      expect(find.byKey(key()), findsOneWidget);

      state.value += 1;
      expect(find.byKey(key()), findsNothing);

      WidgetsBinding.instance.buildIntermediately();
      expect(find.byKey(key()), findsOneWidget);

      await tester.pump();
      expect(find.byKey(key()), findsOneWidget);
    });

    testWidgets('rebuild elements in LayoutBuilder', (tester) async {
      final state = ValueNotifier(0);
      ValueKey<int> key() => ValueKey(state.value);

      await tester.pumpWidget(
        ValueListenableBuilder<int>(
          valueListenable: state,
          builder: (context, value, _) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(key: ValueKey(value));
              },
            );
          },
        ),
      );

      expect(find.byKey(key()), findsOneWidget);

      state.value += 1;
      expect(find.byKey(key()), findsNothing);

      WidgetsBinding.instance.buildIntermediately();
      expect(find.byKey(key()), findsOneWidget);

      await tester.pump();
      expect(find.byKey(key()), findsOneWidget);
    });

    group('run post build callback', () {
      testWidgets('from intermediate build', (tester) async {
        final state = ValueNotifier(0);

        await tester.pumpWidget(
          ValueListenableBuilder<int>(
            valueListenable: state,
            builder: (context, _, __) => PostBuildCallbackCounter(),
          ),
        );
        final counterState = tester.state<_PostBuildCallbackCounterState>(
          find.byType(PostBuildCallbackCounter),
        );
        expect(counterState.count, 1);

        state.value += 1;
        WidgetsBinding.instance.buildIntermediately();
        expect(counterState.count, 2);
      });

      testWidgets('from frame build', (tester) async {
        final state = ValueNotifier(0);

        await tester.pumpWidget(
          ValueListenableBuilder<int>(
            valueListenable: state,
            builder: (context, _, __) => PostBuildCallbackCounter(),
          ),
        );
        final counterState = tester.state<_PostBuildCallbackCounterState>(
          find.byType(PostBuildCallbackCounter),
        );
        expect(counterState.count, 1);

        state.value += 1;
        await tester.pump();
        expect(counterState.count, 2);
      });
    });
  });
}

class PostBuildCallbackCounter extends StatefulWidget {
  // We don't want this to be const because we want to rebuild the widget every
  // time it's built.
  // ignore: prefer_const_constructors_in_immutables
  PostBuildCallbackCounter({super.key});

  @override
  State<PostBuildCallbackCounter> createState() =>
      _PostBuildCallbackCounterState();
}

class _PostBuildCallbackCounterState extends State<PostBuildCallbackCounter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    schedulePostBuildCallback(() {
      count += 1;
    });
    return const SizedBox();
  }
}
