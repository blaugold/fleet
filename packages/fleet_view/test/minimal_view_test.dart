import 'package:fleet_view/fleet_view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

part 'minimal_view_test.g.dart';

void main() {
  testWidgets('can build', (tester) async {
    await tester.pumpWidget(MinimalView());
    expect(find.byType(SizedBox), findsOneWidget);
  });
}

@viewGen
abstract class _MinimalView extends ViewWidget {
  _MinimalView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
