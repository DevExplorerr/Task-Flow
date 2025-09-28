import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final Color buttonColor;
  final Color buttonTextColor;
  final String buttonText;
  final double? fontSize;
  const CustomButton({
    super.key,
    required this.onPressed,
    this.height,
    this.width,
    required this.buttonColor,
    required this.buttonText,
    this.fontSize,
    required this.buttonTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: GoogleFonts.cambo(
            color: buttonTextColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
