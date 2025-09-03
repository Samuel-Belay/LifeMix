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
    final now = TZDateTime.now(local);
    var scheduledDate = TZDateTime(local, now.year, now.month, now.day,
        dailyTime.hour, dailyTime.minute, 0);

    // Schedule for next day if time already passed
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _flutterLocal.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'habit_channel', 'Habit Reminders',
          channelDescription: 'Daily habit reminder',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> showImmediate(String title, String body) async {
    await _flutterLocal.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'habit_channel', 'Habit Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}
