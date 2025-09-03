import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:timezone/timezone.dart';

class NotificationService {
  static final _flutterLocal = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    initializeTimeZones();
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _flutterLocal.initialize(settings);
  }

  Future<void> scheduleDaily(
      int id, String title, String body, Time dailyTime) async {
    await _flutterLocal.zonedSchedule(
      id,
      title,
      body,
      TZDateTime.now(local).replace(
        hour: dailyTime.hour,
        minute: dailyTime.minute,
        second: 0,
      ).add(const Duration(days: 1)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'habit_channel', 'Habit Reminders',
          channelDescription: 'Daily habit reminder',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
