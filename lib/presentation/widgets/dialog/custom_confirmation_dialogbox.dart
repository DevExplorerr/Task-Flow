// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/core/constants/app_colors.dart';
import 'package:task_management_app/presentation/widgets/buttons/custom_button.dart';

class CustomConfirmationDialogbox extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String buttonText;
  final String? contentText;
  const CustomConfirmationDialogbox({
    super.key,
    required this.onPressed,
    required this.title,
    required this.buttonText,
    this.contentText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.white
        : AppColors.black;
    return AlertDialog(
      backgroundColor: theme.dialogBackgroundColor,
      title: Text(
        title,
        style: theme.textTheme.headlineSmall,
      ),
      content: (contentText != null && contentText!.isNotEmpty)
          ? Text(
              contentText!,
              textAlign: TextAlign.start,
              style: GoogleFonts.raleway(
                color: textColor,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            )
          : null,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: theme.textButtonTheme.style?.textStyle?.resolve({}),
          ),
        ),
        CustomButton(
          onPressed: onPressed,
          buttonText: buttonText,
        ),
      ],
    );
  }
}
