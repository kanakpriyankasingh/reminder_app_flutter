import 'package:flutter/material.dart';
import 'reminder_home.dart';

void main() {
  runApp(const ReminderApp());
}

class ReminderApp extends StatelessWidget {
  const ReminderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Reminder App',
      home: ReminderHome(),
    );
  }
}
