import 'package:flutter_test/flutter_test.dart';

import 'package:byxex_match/app.dart';

void main() {
  testWidgets('Byxex Match app builds', (WidgetTester tester) async {
    await tester.pumpWidget(const ByxexMatchApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(ByxexMatchApp), findsOneWidget);
  });
}
