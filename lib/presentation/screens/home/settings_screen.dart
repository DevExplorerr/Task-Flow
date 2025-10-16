// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/core/constants/app_colors.dart';
import 'package:task_management_app/logic/provider/theme_provider.dart';
import 'package:task_management_app/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:task_management_app/presentation/widgets/buttons/custom_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Helper function to get a user-friendly name for the current theme
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
    // Use context.watch to listen for changes in the ThemeProvider
    final themeProvider = context.watch<ThemeProvider>();

    // Determine the icon color based on the current theme brightness
    final iconAndTextColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : blackColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: const CustomAppBar(
          title: "General",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25.0,
          vertical: kToolbarHeight,
        ),
        child: Column(
          children: [
            GestureDetector(
              // The onTap callback is now async to await the dialog result
              onTap: () async {
                // Get the current theme mode as a lowercase string (e.g., 'system')
                final currentTheme = themeProvider.themeMode.name;

                // Show the dialog and wait for the user to make a choice
                final newThemeName =
                    await showThemeChoiceDialog(context, currentTheme);

                // If the user selected a theme and pressed "Ok" (result is not null)
                if (newThemeName != null) {
                  ThemeMode newThemeMode;
                  // Convert the string result back into a ThemeMode enum
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
                  // Update the theme using the provider.
                  // Use context.read inside a callback/function.
                  context.read<ThemeProvider>().setThemeMode(newThemeMode);
                }
              },
              child: Row(
                children: [
                  Icon(
                    Icons.light_mode,
                    color: iconAndTextColor,
                  ),
                  const SizedBox(width: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Color Scheme",
                        style: GoogleFonts.poppins(
                          color: iconAndTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // This Text widget now displays the currently active theme
                      Text(
                        _getThemeModeName(themeProvider.themeMode),
                        style: GoogleFonts.poppins(
                          color: iconAndTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 35),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Icon(
                    Icons.brush,
                    color: iconAndTextColor,
                  ),
                  const SizedBox(width: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Accent Color",
                        style: GoogleFonts.poppins(
                          color: iconAndTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Default",
                        style: GoogleFonts.poppins(
                          color: iconAndTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 35),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Icon(
                    Icons.language,
                    color: iconAndTextColor,
                  ),
                  const SizedBox(width: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Language",
                        style: GoogleFonts.poppins(
                          color: iconAndTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "English",
                        style: GoogleFonts.poppins(
                          color: iconAndTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> showThemeChoiceDialog(BuildContext context, String current) {
    String temp = current;
    // The rest of your dialog code remains the same as it's perfectly fine!
    // I've just adjusted the colors to be more theme-friendly.
    final dialogTextColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : textColor;

    final dialogTitleColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : blackColor;

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
            radioTheme: RadioThemeData(
              fillColor: WidgetStateProperty.all(blackColor),
            ),
          ),
          child: AlertDialog(
            elevation: 10,
            title: Text(
              'Choose theme',
              style: GoogleFonts.poppins(
                color: dialogTitleColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  // Removed the non-standard RadioGroup widget
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioMenuButton<String>(
                      value: 'system',
                      groupValue: temp,
                      onChanged: (v) => setState(() => temp = v!),
                      child: Text(
                        'System (Default)',
                        style: GoogleFonts.poppins(
                          color: dialogTextColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    RadioMenuButton<String>(
                      value: 'light',
                      groupValue: temp,
                      onChanged: (v) => setState(() => temp = v!),
                      child: Text(
                        'Light Mode',
                        style: GoogleFonts.poppins(
                          color: dialogTextColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    RadioMenuButton<String>(
                      value: 'dark',
                      groupValue: temp,
                      onChanged: (v) => setState(() => temp = v!),
                      child: Text(
                        'Dark Mode',
                        style: GoogleFonts.poppins(
                          color: dialogTextColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
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
                  style: GoogleFonts.raleway(
                    color: dialogTitleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CustomButton(
                onPressed: () => Navigator.of(context).pop(temp),
                buttonColor: primaryButtonColor,
                buttonText: "Ok",
                buttonTextColor: whiteColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
