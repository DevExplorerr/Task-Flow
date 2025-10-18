// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/core/constants/app_colors.dart';
import 'package:task_management_app/logic/provider/settings_provider.dart';
import 'package:task_management_app/logic/provider/theme_provider.dart';
import 'package:task_management_app/logic/services/notification_service.dart';
import 'package:task_management_app/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:task_management_app/presentation/widgets/buttons/custom_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _getThemeModeName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
      case ThemeMode.system:
        return 'System (Default)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final settingsProvider = context.watch<SettingsProvider>();

    final theme = Theme.of(context);
    final brightnessCheck = theme.brightness == Brightness.dark;
    final textColor =
        brightnessCheck ? AppColors.textDark : AppColors.textLight;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: const CustomAppBar(
          title: "General",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: kToolbarHeight,
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.only(left: 20),
              title: Text(
                "Color Scheme",
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                _getThemeModeName(themeProvider.themeMode),
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: Icon(
                Icons.light_mode,
                color: theme.iconTheme.color,
              ),
              onTap: () async {
                final currentTheme = themeProvider.themeMode.name;

                final newThemeName = await showThemeChoiceDialog(
                  context,
                  currentTheme,
                );

                if (newThemeName != null) {
                  ThemeMode newThemeMode;
                  switch (newThemeName) {
                    case 'light':
                      newThemeMode = ThemeMode.light;
                      break;
                    case 'dark':
                      newThemeMode = ThemeMode.dark;
                      break;
                    case 'system':
                    default:
                      newThemeMode = ThemeMode.system;
                      break;
                  }
                  context.read<ThemeProvider>().setThemeMode(newThemeMode);
                }
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              title: Text(
                "Notification",
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                settingsProvider.notificationEnabled ? "Enabled" : "Disabled",
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: Icon(
                settingsProvider.notificationEnabled
                    ? Icons.notifications_active_outlined
                    : Icons.notifications_off_outlined,
                color: theme.iconTheme.color,
              ),
              trailing: Switch(
                value: settingsProvider.notificationEnabled,
                onChanged: (newValue) async {
                  context
                      .read<SettingsProvider>()
                      .toggleNotifications(newValue);
                  if (newValue) {
                    await NotificationService.checkAndRequestPermission(
                        context);
                  }
                },
                activeTrackColor:
                    brightnessCheck ? AppColors.white : AppColors.black,
                activeThumbColor:
                    brightnessCheck ? AppColors.black : AppColors.white,
                inactiveThumbColor:
                    brightnessCheck ? AppColors.white : AppColors.black,
                inactiveTrackColor:
                    brightnessCheck ? AppColors.black : AppColors.white,
              ),
              onTap: () async {
                final currentValue = settingsProvider.notificationEnabled;
                context
                    .read<SettingsProvider>()
                    .toggleNotifications(!currentValue);

                if (!currentValue) {
                  await NotificationService.checkAndRequestPermission(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> showThemeChoiceDialog(BuildContext context, String current) {
    String temp = current;
    final theme = Theme.of(context);
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      animationStyle: AnimationStyle(
        curve: Curves.easeInQuart,
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 200),
      ),
      builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(
            radioTheme: theme.radioTheme,
          ),
          child: AlertDialog(
            // ignore: deprecated_member_use
            backgroundColor: Theme.of(context).dialogBackgroundColor,
            elevation: 10,
            title: Text(
              'Choose theme',
              style: theme.textTheme.headlineSmall,
            ),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioMenuButton<String>(
                      value: 'system',
                      groupValue: temp,
                      onChanged: (v) => setState(() => temp = v!),
                      child: Text(
                        'System (Default)',
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    RadioMenuButton<String>(
                      value: 'light',
                      groupValue: temp,
                      onChanged: (v) => setState(() => temp = v!),
                      child: Text(
                        'Light Mode',
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    RadioMenuButton<String>(
                      value: 'dark',
                      groupValue: temp,
                      onChanged: (v) => setState(() => temp = v!),
                      child: Text(
                        'Dark Mode',
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: Text(
                  'Cancel',
                  style: theme.textButtonTheme.style!.textStyle!.resolve({}),
                ),
              ),
              CustomButton(
                onPressed: () => Navigator.of(context).pop(temp),
                buttonText: "Ok",
              ),
            ],
          ),
        );
      },
    );
  }
}
