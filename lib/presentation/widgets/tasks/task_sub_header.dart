import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/presentation/widgets/dialog/custom_confirmation_dialogbox.dart';
import '../../../core/constants/app_colors.dart';

class TaskSubHeader extends StatelessWidget {
  final VoidCallback ondeleteAll;
  final int taskCount;
  const TaskSubHeader({
    super.key,
    required this.ondeleteAll,
    required this.taskCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightnessCheck = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total Tasks: $taskCount",
            style: theme.textTheme.titleSmall,
          ),
          TextButton(
            style: TextButton.styleFrom(
              overlayColor: taskCount == 0
                  ? Colors.transparent
                  : brightnessCheck
                      ? AppColors.white
                      : AppColors.black,
            ),
            onPressed: taskCount == 0
                ? null
                : () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      animationStyle: AnimationStyle(
                        curve: Curves.easeInQuart,
                        duration: const Duration(milliseconds: 300),
                        reverseDuration: const Duration(milliseconds: 200),
                      ),
                      builder: (context) => CustomConfirmationDialogbox(
                        title: "Delete all tasks?",
                        buttonText: "Delete",
                        onPressed: () {
                          ondeleteAll();
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
            child: Text(
              "Delete All",
              style: GoogleFonts.poppins(
                color: taskCount == 0
                    ? AppColors.grey
                    : brightnessCheck
                        ? AppColors.textDark
                        : AppColors.textLight,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
