import 'package:flutter_test/flutter_test.dart';
import 'package:reminder_app/main.dart';  // Update this to match your project structure

void main() {
  testWidgets('Reminder App has a title', (WidgetTester tester) async {
    await tester.pumpWidget(const ReminderApp()); // Change MyApp to ReminderApp

    final titleFinder = find.text('Reminder App');
    expect(titleFinder, findsOneWidget);
  });

  // Add more tests as needed
}
