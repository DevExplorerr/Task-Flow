import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final String buttonText;
  final double? fontSize;
  const CustomButton({
    super.key,
    required this.onPressed,
    this.height,
    this.width,
    required this.buttonText,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.black
        : AppColors.white;
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: GoogleFonts.cambo(
            fontSize: fontSize,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
