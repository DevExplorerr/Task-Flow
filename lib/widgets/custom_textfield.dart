import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/widgets/colors.dart';

class CustomTextfield extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final IconButton? suffixIcon;
  final bool? obsecureText;
  final int? maxLines;

  const CustomTextfield({
    super.key,
    required this.hintText,
    this.keyboardType,
    this.suffixIcon,
    this.obsecureText,
    required this.controller,
    required this.text,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        TextFormField(
          style: GoogleFonts.poppins(color: textColor),
          maxLines: maxLines ?? 1,
          keyboardType: keyboardType,
          controller: controller,
          textInputAction: TextInputAction.next,
          obscureText: obsecureText ?? false,
          decoration: inputDecoration().copyWith(
            hintText: hintText,
            hintStyle: GoogleFonts.podkova(
                color: inputHintTextColor, fontWeight: FontWeight.bold),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  InputDecoration inputDecoration() => InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: inputBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: blackColor),
        ),
      );
}
