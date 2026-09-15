import 'package:flutter_test/flutter_test.dart';
import 'package:vintora/main.dart';

void main() {
  testWidgets('VintoraApp dashboard smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VintoraApp());
    expect(find.text('VINTORA SPECIALTY BREW'), findsOneWidget);
    expect(find.text('Hario V60 Dripper'), findsOneWidget);
  });
}
