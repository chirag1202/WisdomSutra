// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:wisdom_sutra/app.dart';

void main() {
  testWidgets('Loads splash then navigates to login',
      (WidgetTester tester) async {
    await tester.pumpWidget(const WisdomSutraApp());
    // Initial frame (splash)
    expect(find.textContaining('WISDOM'), findsOneWidget);
    // Advance time to allow navigation (simulate animation + delay)
    await tester.pump(const Duration(seconds: 3));
    // After delay login screen should show "Login" heading
    expect(find.text('Login'), findsOneWidget);
  });
}
