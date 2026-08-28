import 'package:flutter_test/flutter_test.dart';

import 'package:dondelodeje/app.dart';

void main() {
  testWidgets('Muestra la pantalla principal', (WidgetTester tester) async {
    await tester.pumpWidget(const DondeLoDejeApp());
    expect(find.text('DondeLoDeje'), findsOneWidget);
    expect(find.text('Recientes'), findsOneWidget);
  });
}
