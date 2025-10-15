// lib/core/provider/theme_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider(this._themeMode);

  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;
  ThemeData get lightTheme => ThemeData.light();
  ThemeData get darkTheme => ThemeData.dark();
  // ThemeData get lightTheme => AppTheme.lightMode;
  // ThemeData get darkTheme => AppTheme.darkMode;

  static Future<ThemeMode> loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('themeMode') ?? 'system';

    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  // Save Theme
  Future<void> _saveTheme(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode);
  }

  // Set Theme
  void setThemeMode(ThemeMode mode) {
    if (mode == _themeMode) {
      return;
    }

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
