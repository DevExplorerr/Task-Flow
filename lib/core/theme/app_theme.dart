// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/core/constants/app_colors.dart';

class AppTheme {
  static final lightMode = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    primaryColor: AppColors.primary,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.black,
      selectionColor: AppColors.grey.withOpacity(0.5),
      selectionHandleColor: AppColors.black,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(
          AppColors.black.withOpacity(0.1),
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(
          AppColors.black.withOpacity(0.1),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(
          AppColors.white.withOpacity(0.1),
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.inputBorder),
      ),
      hintStyle: TextStyle(color: AppColors.inputHint),
      iconColor: AppColors.inputIcon,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.secondary,
    ),
  );

  static final darkMode = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.primary,
    primaryColor: AppColors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.black,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.white),
      titleTextStyle: TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.white,
      selectionColor: AppColors.grey.withOpacity(0.5),
      selectionHandleColor: AppColors.white,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(
          AppColors.white.withOpacity(0.1),
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(
          AppColors.white.withOpacity(0.1),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(
          AppColors.black.withOpacity(0.1),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.inputBorder),
      ),
      hintStyle: GoogleFonts.poppins(color: AppColors.inputHint),
      iconColor: AppColors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.black,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xff1E1E1E),
    ),
  );
}
