import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/widgets/colors.dart';
import 'package:task_management_app/widgets/custom_button.dart';
import 'package:task_management_app/widgets/custom_textfield.dart';

class CustomBottomSheet extends StatelessWidget {
  final String hintText;
  final String text;
  final String buttonText;
  final VoidCallback onPressed;
  final TextEditingController controller;
  const CustomBottomSheet(
      {super.key,
      required this.hintText,
      required this.text,
      required this.buttonText,
      required this.onPressed,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                left: 20.w, right: 20.w, top: 10.h, bottom: 30.h),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                CustomTextfield(
                  hintText: hintText,
                  controller: controller,
                  text: text,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  autoFocus: true,
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel",
                          style: GoogleFonts.poppins(color: textColor)),
                    ),
                    SizedBox(width: 10.w),
                    CustomButton(
                        buttonColor: primaryButtonColor,
                        buttonText: buttonText,
                        buttonTextColor: primaryButtonTextColor,
                        fontSize: 14.sp,
                        onPressed: onPressed),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
