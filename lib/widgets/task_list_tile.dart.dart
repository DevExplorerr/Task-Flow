import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/widgets/custom_button.dart';
import 'package:task_management_app/widgets/custom_textfield.dart';
import 'colors.dart';

class TaskListTile extends StatefulWidget {
  final String taskTitle;
  final VoidCallback onDelete;
  final ValueChanged<String> onEdit;
  final bool isCompleted;
  final ValueChanged<bool> onStatusToggle;
  const TaskListTile(
      {super.key,
      required this.taskTitle,
      required this.onDelete,
      required this.onEdit,
      required this.isCompleted,
      required this.onStatusToggle});

  @override
  State<TaskListTile> createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: inputBorderColor, width: 1),
      ),
      child: ListTile(
        minTileHeight: 40.h,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        tileColor: bgColor,
        title: GestureDetector(
          onTap: () {
            showModalBottomSheet(
                elevation: 10,
                backgroundColor: bgColor,
                showDragHandle: true,
                isScrollControlled: true,
                context: context,
                builder: (context) => _buildBottomSheet(context));
          },
          child: Text(
            widget.taskTitle,
            style: GoogleFonts.poppins(
              color:
                  widget.isCompleted ? listViewCompletedTextColor : textColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              decoration: widget.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            setState(() {
              widget.onStatusToggle(!widget.isCompleted);
            });
          },
          icon: Icon(
            widget.isCompleted
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded,
            color: widget.isCompleted
                ? listViewCheckBoxColor
                : listViewUnfillCheckBoxColor,
            size: 28.sp,
          ),
        ),
        trailing: IconButton(
          onPressed: widget.onDelete,
          icon: const Icon(
            Icons.close_sharp,
            color: listViewDeleteIconColor,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: widget.taskTitle);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.w),
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
                  hintText: "Edit your task...",
                  controller: controller,
                  text: "Edit Task",
                  maxLines: 2,
                  keyboardType: TextInputType.multiline,
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
                      buttonText: "Save",
                      buttonTextColor: primaryButtonTextColor,
                      fontSize: 14.sp,
                      onPressed: () {
                        if (controller.text.trim().isNotEmpty) {
                          widget.onEdit(controller.text.trim());
                          Navigator.pop(context);
                        }
                      },
                    ),
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
