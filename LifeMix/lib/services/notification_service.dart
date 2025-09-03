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

  /// Schedule a daily notification at [dailyTime]
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

  /// Send an immediate notification
  Future<void> showNotification(int id, String title, String body) async {
    await _flutterLocal.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_channel', 'Instant Notifications',
          channelDescription: 'Immediate notifications for user actions',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  /// Cancel a specific notification by [id]
  Future<void> cancelNotification(int id) async {
    await _flutterLocal.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocal.cancelAll();
  }

  /// List all pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocal.pendingNotificationRequests();
  }
}
