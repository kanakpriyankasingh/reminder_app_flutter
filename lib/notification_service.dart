import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    // ignore: prefer_const_declarations
    final InitializationSettings initializationSettings = const InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  Future<void> scheduleNotification(
      String? selectedDay, TimeOfDay? selectedTime, String? selectedActivity) async {
    if (selectedDay != null && selectedTime != null && selectedActivity != null) {
      final scheduledDate = tz.TZDateTime.now(tz.local).add(Duration(days: (getDayOffset(selectedDay))));

      scheduledDate.add(Duration(
        hours: selectedTime.hour,
        minutes: selectedTime.minute,
      ));

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Reminder for $selectedActivity',
        'It\'s time for $selectedActivity',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your_channel_id',
            'Your Channel Name',
            channelDescription: 'Your Channel Description',
            importance: Importance.max,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound('notification_sound'), // Use your sound file
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  int getDayOffset(String selectedDay) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days.indexOf(selectedDay) - DateTime.now().weekday + 1;
  }
}
