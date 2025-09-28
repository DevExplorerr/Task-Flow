import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/widgets/colors.dart';
import 'package:task_management_app/widgets/custom_button.dart';

class CustomConfirmationDialogbox extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String buttonText;
  const CustomConfirmationDialogbox(
      {super.key,
      required this.onPressed,
      required this.title,
      required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: bgColor,
      title: Text(
        title,
        style: GoogleFonts.raleway(
          color: blackColor,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: GoogleFonts.raleway(
              color: blackColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        CustomButton(
            onPressed: onPressed,
            buttonColor: primaryButtonColor,
            buttonText: buttonText,
            buttonTextColor: whiteColor)
      ],
    );
  }
}
