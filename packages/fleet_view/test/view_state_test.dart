// ignore_for_file: must_be_immutable

import 'package:fleet_view/fleet_view.dart';
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
      Directionality(
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

@viewGen
abstract class _ClickCounterView extends ViewWidget {
  _ClickCounterView({super.key});

  abstract final String? prefix;

  @state
  late var _clicks = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _clicks++,
      child: Text('${prefix ?? ''}$_clicks'),
    );
  }
}
