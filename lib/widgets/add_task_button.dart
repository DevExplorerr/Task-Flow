import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/widgets/colors.dart';
import 'package:task_management_app/widgets/custom_dialogbox.dart';

class AddTaskButton extends StatefulWidget {
  final Function(String) onAddTask;
  const AddTaskButton({
    super.key,
    required this.onAddTask,
  });

  @override
  State<AddTaskButton> createState() => _AddTaskButtonState();
}

class _AddTaskButtonState extends State<AddTaskButton> {
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          animationStyle: AnimationStyle(
            curve: Curves.easeInQuart,
            duration: const Duration(milliseconds: 300),
            reverseDuration: const Duration(milliseconds: 200),
          ),
          builder: (context) => CustomDialogbox(
            controller: titleController,
            text: 'Add New Task',
            hintText: "Add task here...",
            labelText: "Title",
            keyboardType: TextInputType.text,
            buttonText: 'Add',
            onPressed: () {
              final taskTitle = titleController.text;
              if (taskTitle.trim().isEmpty) return;
              widget.onAddTask(taskTitle);
              titleController.clear();
              Navigator.of(context).pop();
            },
          ),
        );
      },
      child: Container(
        height: 45.h,
        width: 55.w,
        decoration: BoxDecoration(
          color: primaryButtonColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            "Add",
            style: GoogleFonts.inter(
              color: primaryButtonTextColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
