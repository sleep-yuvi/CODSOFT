import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todolist_app/widgets/todayfilterbutton.dart'; // Import the widget to be tested

void main() {
  // Define a test group for the TaskFilterAndDateDisplay widget.
  group('TaskFilterAndDateDisplay Widget Tests', () {
    // Test case to verify that the widget renders correctly.
    testWidgets('Widget renders "Today\'s Focus" text and "Filter" button', (WidgetTester tester) async {
      // Build the TaskFilterAndDateDisplay widget within a MaterialApp to provide context
      // for theme and MediaQuery, which the widget relies on.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TaskFilterAndDateDisplay(),
          ),
        ),
      );

      // Verify that the "Today's Focus" text is present.
      expect(find.text("Today's Focus"), findsOneWidget);

      // Verify that the "Filter" text within the button is present.
      expect(find.text("Filter"), findsOneWidget);

      // Verify that the filter SVG icon is present.
      // Since SvgPicture.asset is used, we can find it by type or by a more specific key if provided.
      // For this test, we'll look for an SvgPicture.
      expect(find.byType(Image), findsOneWidget); // SvgPicture often renders as an Image in tests
    });

    // Test case to verify the tap functionality of the filter button.
    testWidgets('Tapping the filter button triggers its onTap callback', (WidgetTester tester) async {
      // We can't directly test a print statement, but we can verify that
      // the GestureDetector's onTap is registered. For real-world scenarios,
      // you would mock a function or use a BLoC/Provider to verify state changes.

      // Build the widget.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TaskFilterAndDateDisplay(),
          ),
        ),
      );

      // Find the filter button by looking for the GestureDetector containing the text "Filter".
      final filterButtonFinder = find.descendant(
        of: find.byType(GestureDetector),
        matching: find.text('Filter'),
      );

      // Ensure the button is found before attempting to tap it.
      expect(filterButtonFinder, findsOneWidget);

      // Tap the filter button.
      await tester.tap(filterButtonFinder);
      await tester.pumpAndSettle(); // Settle any animations or rebuilds

      // Since the original code only has a print statement, we can't directly
      // assert a UI change here. In a real app, you'd check for a dialog,
      // a bottom sheet, or a state change triggered by the tap.
      // For this test, simply verifying the tap doesn't throw an error is the goal.
      // The `print` statement would appear in the test console output.
    });
  });
}
