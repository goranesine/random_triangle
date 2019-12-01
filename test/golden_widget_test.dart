import 'package:flutter_test/flutter_test.dart';
import 'package:zajebancija/main.dart';
void main() {
  testWidgets('Golden test', (WidgetTester tester) async {
    await tester.pumpWidget(Test());
    await expectLater(find.byType(Test), matchesGoldenFile('main.png'));
  });
}