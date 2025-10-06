// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_management_app/widgets/colors.dart';
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
    const iosInit = DarwinInitializationSettings();

    const settings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _notificationsPlugin.initialize(settings);
  }

  // Check and request notification permission
  static Future<void> checkAndRequestPermission(BuildContext context) async {
    final status = await Permission.notification.status;

    if (status.isGranted) return;

    if (status.isDenied || status.isRestricted) {
      final result = await Permission.notification.request();
      if (result.isGranted) return;
    }

    if (status.isPermanentlyDenied) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: whiteColor,
          title: const Text("Enable Notifications"),
          content: const Text(
            "To receive task reminders, please allow notifications from app settings.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await openAppSettings();
              },
              child: const Text("Open Settings"),
            ),
          ],
        ),
      );
    }
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
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  // Cancel Notifications
  static Future<void> cancelNotification(String taskId) async {
    await _notificationsPlugin.cancel(taskId.hashCode);
  }
}

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



  // // Request permission for notification
  // static Future<void> requestPermission() async {
  //   // Android
  //   await _notificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin>()
  //       ?.requestNotificationsPermission();

  //   // Ios
  //   await _notificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           IOSFlutterLocalNotificationsPlugin>()
  //       ?.requestPermissions(alert: true, badge: true, sound: true);
  // }