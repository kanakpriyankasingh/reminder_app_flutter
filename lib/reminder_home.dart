import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'reminder.dart';

class ReminderHome extends StatefulWidget {
  const ReminderHome({Key? key}) : super(key: key);

  @override
  ReminderHomeState createState() => ReminderHomeState();
}

class ReminderHomeState extends State<ReminderHome> {
  String? _selectedDay;
  TimeOfDay? _selectedTime;
  String? _selectedActivity;

  final List<String> _activities = [
    'Wake up',
    'Go to gym',
    'Breakfast',
    'Meetings',
    'Lunch',
    'Quick nap',
    'Go to library',
    'Dinner',
    'Go to sleep',
  ];

  final List<Reminder> _reminders = [];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Channel for reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void _scheduleReminder() {
    if (_selectedDay != null && _selectedTime != null && _selectedActivity != null) {
      final now = DateTime.now();
      var reminderTime = DateTime(now.year, now.month, now.day, _selectedTime!.hour, _selectedTime!.minute);
      if (reminderTime.isBefore(now)) {
        reminderTime = reminderTime.add(const Duration(days: 1));
      }

      final delay = reminderTime.difference(now).inSeconds;
      Future.delayed(Duration(seconds: delay), () {
        _showNotification('Reminder', 'Time for $_selectedActivity');
      });

      setState(() {
        _reminders.add(Reminder(day: _selectedDay!, time: _selectedTime!, activity: _selectedActivity!));
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reminder set for $_selectedActivity at ${_selectedTime!.format(context)}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              hint: const Text('Select Day'),
              value: _selectedDay,
              onChanged: (newValue) {
                setState(() {
                  _selectedDay = newValue;
                });
              },
              items: const [
                'Monday', 'Tuesday', 'Wednesday',
                'Thursday', 'Friday', 'Saturday', 'Sunday'
              ].map((day) {
                return DropdownMenuItem(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() {
                    _selectedTime = time;
                  });
                }
              },
              child: Text(_selectedTime == null ? 'Select Time' : _selectedTime!.format(context)),
            ),
            const SizedBox(height: 16.0),
            DropdownButton<String>(
              hint: const Text('Select Activity'),
              value: _selectedActivity,
              onChanged: (newValue) {
                setState(() {
                  _selectedActivity = newValue;
                });
              },
              items: _activities.map((activity) {
                return DropdownMenuItem(
                  value: activity,
                  child: Text(activity),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _scheduleReminder,
              child: const Text('Set Reminder'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _reminders.length,
                itemBuilder: (context, index) {
                  final reminder = _reminders[index];
                  return ListTile(
                    title: Text('${reminder.activity} on ${reminder.day} at ${reminder.time.format(context)}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
