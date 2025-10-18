import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management_app/logic/services/notification_service.dart';

class SettingsProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  bool _notificationEnabled = true;
  static const String _kNotificationsKey = "notifications_enabled";

  bool get notificationEnabled => _notificationEnabled;

  SettingsProvider(this._prefs) {
    _loadSettings();
  }

  void _loadSettings() async {
    _notificationEnabled = _prefs.getBool(_kNotificationsKey) ?? true;
  }

  Future<void> toggleNotifications(bool newValue) async {
    _notificationEnabled = newValue;
    await _prefs.setBool(_kNotificationsKey, newValue);

    if (!newValue) {
      await NotificationService.cancelAllNotifications();
    }
    notifyListeners();
  }
}
