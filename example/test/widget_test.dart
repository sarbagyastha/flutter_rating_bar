// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:material_ui/material_ui.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_rating_bar_example/main.dart';

void main() {
  testWidgets('Example app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the rating bar and both indicators are shown.
    expect(find.byType(RatingBar), findsWidgets);
    expect(find.byType(RatingBarIndicator), findsWidgets);

    // Verify that the star items are built from Material icons.
    expect(find.byIcon(Icons.star), findsWidgets);
  });
}
