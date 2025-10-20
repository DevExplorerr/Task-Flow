// lib/core/provider/theme_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management_app/core/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  final SharedPreferences? prefs;

  ThemeProvider({this.prefs}) {
    _loadTheme();
  }

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  ThemeData get lightTheme => AppTheme.lightMode;
  ThemeData get darkTheme => AppTheme.darkMode;

  void _loadTheme() {
    final theme = prefs?.getString('themeMode') ?? 'system';

    switch (theme) {
      case 'light':
        _themeMode = ThemeMode.light;
      case 'dark':
        _themeMode = ThemeMode.dark;
      default:
        _themeMode = ThemeMode.system;
    }
  }

  // Save Theme
  Future<void> _saveTheme(String mode) async {
    await prefs?.setString('themeMode', mode);
  }

  // Set Theme
  void setThemeMode(ThemeMode mode) {
    if (mode == _themeMode) return;

    _themeMode = mode;
    notifyListeners();

    _saveTheme(_themeMode.name);
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
}
