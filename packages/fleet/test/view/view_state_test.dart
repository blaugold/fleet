import 'package:fleet/fleet.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

part 'view_state_test.g.dart';

void main() {
  testWidgets('rebuilds when widget changes', (tester) async {
    final text = ValueNotifier('a');

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ValueListenableBuilder<String>(
          valueListenable: text,
          builder: (context, value, _) => ClickCounterView(prefix: value),
        ),
      ),
    );

    expect(find.text('a0'), findsOneWidget);

    text.value = 'b';
    await tester.pump();

    expect(find.text('b0'), findsOneWidget);
  });

  testWidgets('rebuilds when state changes', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: ClickCounterView(),
      ),
    );

    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.byType(ClickCounterView));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });
}

@view
abstract class _ClickCounterView extends _$ClickCounterView {
  abstract final String? prefix;

  @state
  late int clicks = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => clicks++,
      child: Text('${prefix ?? ''}$clicks'),
    );
  }
}