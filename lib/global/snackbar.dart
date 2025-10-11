import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/constants/colors.dart';

void showFloatingSnackBar(
  BuildContext context, {
  required String message,
  required Color backgroundColor,
  Duration duration = const Duration(seconds: 1),
  SnackBarAction? action,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final fontSize = screenWidth * 0.035;
  final horizontalMargin = screenWidth * 0.04;
  final bottomMargin = screenWidth * 0.05;
  final borderRadius = screenWidth * 0.03;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          color: whiteColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        left: horizontalMargin,
        right: horizontalMargin,
        bottom: bottomMargin,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      action: action,
    ),
  );
}
