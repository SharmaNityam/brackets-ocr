import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ocr/main.dart';

void main() {
  testWidgets('OCR App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const OCRApp());

    // Verify that the app starts with the camera screen
    expect(find.text('OCR Scanner'), findsOneWidget);

    // Verify that the history button is present
    expect(find.byIcon(Icons.history), findsOneWidget);
  });

  testWidgets('Navigation to history screen', (WidgetTester tester) async {
    await tester.pumpWidget(const OCRApp());

    // Tap the history button
    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();

    // Verify that we navigated to the history screen
    expect(find.text('Scan History'), findsOneWidget);
  });
}
