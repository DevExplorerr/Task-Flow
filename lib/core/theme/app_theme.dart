// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/core/constants/app_colors.dart';

class AppTheme {
  static final lightMode = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    dialogBackgroundColor: AppColors.white,
    primaryColor: AppColors.black,
    cardColor: AppColors.secondary,
    

    // Text Theme
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: AppColors.textLight,
        fontSize: 28,
      ),
      headlineMedium: GoogleFonts.poppins(
        color: AppColors.textLight,
        fontSize: 22,
        fontWeight: FontWeight.w400,
      ),
      headlineSmall: GoogleFonts.poppins(
        color: AppColors.textLight,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: GoogleFonts.poppins(
        color: AppColors.textLight,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),

      // For Text Field Title
      titleSmall: GoogleFonts.poppins(
        color: AppColors.textLight,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),

      // Home App Bar
      titleMedium: GoogleFonts.poppins(
        color: AppColors.textLight,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      titleLarge: GoogleFonts.poppins(
        color: AppColors.textLight,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.black,
      selectionColor: AppColors.grey.withOpacity(0.5),
      selectionHandleColor: AppColors.black,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll<TextStyle?>(
          GoogleFonts.raleway(
            color: AppColors.textLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        overlayColor: MaterialStateProperty.all(
          AppColors.black.withOpacity(0.1),
        ),
      ),
    ),

    // Icon Theme
    iconTheme: IconThemeData(color: AppColors.inputIcon),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(
          AppColors.black.withOpacity(0.1),
        ),
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          AppColors.primary,
        ),
        overlayColor: MaterialStateProperty.all(
          AppColors.white.withOpacity(0.1),
        ),
      ),
    ),

    // Drawer Theme
    drawerTheme: DrawerThemeData(
      backgroundColor: AppColors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
      ),
    ),

    // Text Fields
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.black),
      ),
      hintStyle: GoogleFonts.podkova(
        color: AppColors.inputHint,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Radio Menu Button
    radioTheme: RadioThemeData(
      fillColor: WidgetStatePropertyAll(AppColors.black),
    ),

    // Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.white,
    ),

    // Bottom Sheet
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.white,
    ),
  );

  // Dark Theme
  static final darkMode = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.black,
    dialogBackgroundColor: AppColors.primary,
    primaryColor: AppColors.secondary,
    cardColor: AppColors.primary,

    // Text Theme
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
        fontSize: 28,
      ),
      headlineMedium: GoogleFonts.poppins(
        color: AppColors.textDark,
        fontSize: 24,
        fontWeight: FontWeight.w400,
      ),
      headlineSmall: GoogleFonts.poppins(
        color: AppColors.textDark,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: GoogleFonts.poppins(
        color: AppColors.textDark,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),

      // For Text Field Title
      titleSmall: GoogleFonts.poppins(
        color: AppColors.textDark,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),

      // Home App Bar
      titleMedium: GoogleFonts.poppins(
        color: AppColors.textDark,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      titleLarge: GoogleFonts.poppins(
        color: AppColors.textDark,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.white,
      selectionColor: AppColors.grey.withOpacity(0.5),
      selectionHandleColor: AppColors.white,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(
          GoogleFonts.raleway(
            color: AppColors.textDark,
            fontWeight: FontWeight.w500,
          ),
        ),
        overlayColor: MaterialStateProperty.all(
          AppColors.white.withOpacity(0.1),
        ),
      ),
    ),

    //App bar not finish
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

    // Icon Theme
    iconTheme: IconThemeData(color: AppColors.secondary),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(
          AppColors.white.withOpacity(0.1),
        ),
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.secondary),
        overlayColor: MaterialStateProperty.all(
          AppColors.black.withOpacity(0.1),
        ),
      ),
    ),

    // Drawer Theme
    drawerTheme: DrawerThemeData(
      backgroundColor: AppColors.black,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
      ),
    ),

    // Text Field
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.secondary),
      ),
      hintStyle: GoogleFonts.podkova(
        color: AppColors.inputHint,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Radio Menu Button
    radioTheme: RadioThemeData(
      fillColor: WidgetStatePropertyAll(AppColors.white),
    ),

    // Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
    ),

    // Bottom Sheet
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.primary,
    ),
  );
}
