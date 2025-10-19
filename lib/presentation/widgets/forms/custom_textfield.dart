import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/core/constants/app_colors.dart';

class CustomTextfield extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final IconButton? suffixIcon;
  final bool? obsecureText;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final bool? autoFocus;

  const CustomTextfield({
    super.key,
    required this.hintText,
    this.keyboardType,
    this.suffixIcon,
    this.obsecureText,
    required this.controller,
    required this.text,
    this.maxLines,
    this.textInputAction,
    this.autoFocus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final darkbrightness = theme.brightness == Brightness.dark;
    final inputTextColor =
        darkbrightness ? AppColors.textDark : AppColors.textLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          style: GoogleFonts.poppins(color: inputTextColor),
          autofocus: autoFocus ?? false,
          maxLines: maxLines ?? 1,
          keyboardType: keyboardType,
          controller: controller,
          textInputAction: textInputAction ?? TextInputAction.next,
          obscureText: obsecureText ?? false,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: theme.inputDecorationTheme.hintStyle,
            suffixIcon: suffixIcon,
            enabledBorder: theme.inputDecorationTheme.enabledBorder,
            focusedBorder: theme.inputDecorationTheme.focusedBorder,
          ),
        ),
      ],
    );
  }
}
