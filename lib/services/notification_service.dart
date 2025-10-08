// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_management_app/widgets/custom_confirmation_dialogbox.dart';
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
  static Future<bool> checkAndRequestPermission(BuildContext context) async {
    final status = await Permission.notification.status;

    if (status.isGranted) return true;

    if (status.isDenied || status.isRestricted) {
      final result = await Permission.notification.request();
      if (result.isGranted) return true;
    }

    if (status.isPermanentlyDenied || status.isDenied) {
      await showDialog(
        context: context,
        animationStyle: AnimationStyle(
          curve: Curves.easeInQuart,
          duration: const Duration(milliseconds: 300),
          reverseDuration: const Duration(milliseconds: 200),
        ),
        builder: (context) => CustomConfirmationDialogbox(
          onPressed: () async {
            Navigator.pop(context);
            await openAppSettings();
          },
          title: "Notifications Disabled",
          contentText:
              "You've denied notification permissions. To receive task reminders, please enable notifications from app settings.",
          buttonText: "Open Settings",
        ),
      );
    }

    return false;
  }

  // Schedule notification for a specific time
  static Future<void> scheduleNotification({
    required String taskId,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final scheduleDate = tz.TZDateTime.from(scheduledTime, tz.local);

    // Skip notification if the reminder is in the past
    if (scheduleDate.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

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

    await _notificationsPlugin.zonedSchedule(
      taskId.hashCode,
      title,
      body,
      scheduleDate,
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
