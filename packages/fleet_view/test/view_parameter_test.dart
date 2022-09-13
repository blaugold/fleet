import 'package:fleet_view/fleet_view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

part 'view_parameter_test.g.dart';

void main() {
  testWidgets('updates on rebuild', (tester) async {
    final text = ValueNotifier('a');

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ValueListenableBuilder<String>(
          valueListenable: text,
          builder: (context, value, _) => TextParameterView(text: value),
        ),
      ),
    );

    expect(find.text('a'), findsOneWidget);

    text.value = 'b';
    await tester.pump();

    expect(find.text('b'), findsOneWidget);
  });
}

@viewGen
abstract class _TextParameterView extends ViewWidget {
  _TextParameterView({super.key});

  abstract final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}

@viewGen
abstract class _OptionalParameterView extends ViewWidget {
  _OptionalParameterView({super.key});

  abstract final String? text;

  @override
  Widget build(BuildContext context) {
    return Text(text ?? 'no text');
  }
}
