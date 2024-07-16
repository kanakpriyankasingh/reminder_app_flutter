import 'package:flutter/material.dart';
import 'notification_service.dart';

class ReminderHome extends StatefulWidget {
  const ReminderHome({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ReminderHomeState createState() => _ReminderHomeState();
}

class _ReminderHomeState extends State<ReminderHome> {
  String? selectedDay;
  TimeOfDay? selectedTime;
  String? selectedActivity;
  final NotificationService notificationService = NotificationService();

  final List<String> daysOfWeek = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  final List<String> activities = [
    'Wake up', 'Go to gym', 'Breakfast', 'Meetings', 'Lunch', 
    'Quick nap', 'Go to library', 'Dinner', 'Go to sleep'
  ];

  @override
  void initState() {
    super.initState();
    notificationService.initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminder App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: const Text('Select Day'),
              value: selectedDay,
              onChanged: (value) {
                setState(() {
                  selectedDay = value;
                });
              },
              items: daysOfWeek.map((day) {
                return DropdownMenuItem(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () async {
                TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                setState(() {
                  selectedTime = time;
                });
              },
              child: const Text('Select Time'),
            ),
            DropdownButton<String>(
              hint: const Text('Select Activity'),
              value: selectedActivity,
              onChanged: (value) {
                setState(() {
                  selectedActivity = value;
                });
              },
              items: activities.map((activity) {
                return DropdownMenuItem(
                  value: activity,
                  child: Text(activity),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                notificationService.scheduleNotification(
                  selectedDay,
                  selectedTime,
                  selectedActivity,
                );
              },
              child: const Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
