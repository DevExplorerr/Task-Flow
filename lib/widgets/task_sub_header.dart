import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/widgets/custom_confirmation_dialogbox.dart';
import 'colors.dart';

class TaskSubHeader extends StatelessWidget {
  final VoidCallback ondeleteAll;
  final int taskCount;
  const TaskSubHeader(
      {super.key, required this.ondeleteAll, required this.taskCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Total Tasks: $taskCount",
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            overlayColor: taskCount == 0 ? Colors.transparent : blackColor,
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
              color: taskCount == 0 ? greyColor : blackColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
