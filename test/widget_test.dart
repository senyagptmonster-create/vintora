import 'package:flutter_test/flutter_test.dart';
import 'package:vintora/vintora_app.dart';

void main() {
  testWidgets('VintoraBrewApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VintoraBrewApp());
    expect(find.byType(VintoraBrewApp), findsOneWidget);
  });
}