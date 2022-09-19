import 'package:fleet/fleet.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

part 'minimal_view_test.g.dart';

void main() {
  testWidgets('can build', (tester) async {
    await tester.pumpWidget(const MinimalView());
    expect(find.byType(SizedBox), findsOneWidget);
  });
}

@view
abstract class _MinimalView extends _$MinimalView {
  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
