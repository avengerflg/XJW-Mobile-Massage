import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xjw_mobile_massage/main.dart';

void main() {
  testWidgets('Login flow test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('XJW Mobile Massage'), findsOneWidget);

    await tester.pump(Duration(seconds: 3)); // Wait for the splash screen delay

    // Check if Login screen is displayed
    expect(find.text('Login'), findsOneWidget);
  });
}
