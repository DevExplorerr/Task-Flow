import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationService {
  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize plugin
  static Future<void> init() async {
    // Timezone setup
    tzdata.initializeTimeZones();

    // Android setup
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS setup
    final iosInit = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    await _notificationsPlugin
        .initialize(InitializationSettings(android: androidInit, iOS: iosInit));
  }

  // Schedule notification for a specific time
  static Future<void> scheduleNotification({
    required String taskId,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Task Reminder Notifications',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);
    final scheduleDate = tz.TZDateTime.from(scheduledTime, tz.local);

    await _notificationsPlugin.zonedSchedule(
      taskId.hashCode,
      title,
      body,
      scheduleDate.isBefore(tz.TZDateTime.now(tz.local))
          ? tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5))
          : scheduleDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelNotification(String taskId) =>
      _notificationsPlugin.cancel(taskId.hashCode);

  static Future<List<PendingNotificationRequest>> pendingRequests() =>
      _notificationsPlugin.pendingNotificationRequests();

  //   // Show an instant notification (for testing)
  // static Future<void> showNotification({
  //   required String title,
  //   required String body,
  // }) async {
  //   const androidDetails = AndroidNotificationDetails(
  //     'reminder_channel', // channel id
  //     'Reminders', // channel name
  //     channelDescription: 'Task Reminder Notifications',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );

  //   const notificationDetails = NotificationDetails(android: androidDetails);

  //   await _notificationsPlugin.show(
  //     0,
  //     title,
  //     body,
  //     notificationDetails,
  //   );
  // }
}
