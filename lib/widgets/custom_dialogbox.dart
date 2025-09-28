import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/widgets/colors.dart';
import 'package:task_management_app/widgets/custom_button.dart';
import 'package:task_management_app/widgets/custom_textfield.dart';

class CustomDialogbox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPressed;
  final String text;
  final String hintText;
  final String labelText;
  final TextInputType keyboardType;
  final String buttonText;
  const CustomDialogbox(
      {super.key,
      required this.controller,
      required this.onPressed,
      required this.text,
      required this.hintText,
      required this.labelText,
      required this.keyboardType,
      required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        backgroundColor: bgColor,
        title: Text(
          text,
          style: GoogleFonts.raleway(
            color: textColor,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextfield(
              hintText: hintText,
              text: labelText,
              controller: controller,
              keyboardType: keyboardType,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.raleway(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CustomButton(
            onPressed: onPressed,
            buttonColor: primaryButtonColor,
            buttonText: buttonText,
            fontSize: 14.sp,
            buttonTextColor: primaryButtonTextColor,
          ),
        ],
      ),
    );
  }
}
