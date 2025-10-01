import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/widgets/custom_bottom_sheet.dart';
import 'colors.dart';

class TaskListTile extends StatefulWidget {
  final String taskTitle;
  final VoidCallback onDelete;
  final ValueChanged<String> onEdit;
  final bool isCompleted;
  final ValueChanged<bool> onStatusToggle;
  final DateTime? reminderDateTime;
  const TaskListTile(
      {super.key,
      required this.taskTitle,
      required this.onDelete,
      required this.onEdit,
      required this.isCompleted,
      required this.onStatusToggle,
      this.reminderDateTime});

  @override
  State<TaskListTile> createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  DateTime? reminderDateTime;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.taskTitle);
    reminderDateTime = widget.reminderDateTime;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
                builder: (context) => CustomBottomSheet(
                      hintText: 'Edit your task...',
                      text: 'Edit Task',
                      buttonText: 'Save',
                      controller: controller,
                      onPressed: () {
                        if (controller.text.trim().isNotEmpty) {
                          widget.onEdit(controller.text.trim());
                          Navigator.pop(context);
                        }
                      },
                      onReminderSelected: (dateTime) {
                        setState(() {
                          reminderDateTime = dateTime;
                        });
                      },
                    ));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.taskTitle,
                style: GoogleFonts.poppins(
                  color: widget.isCompleted
                      ? listViewCompletedTextColor
                      : textColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  decoration: widget.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              if (reminderDateTime != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.alarm,
                      color: Colors.red[300],
                      size: 20.sp,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      DateFormat("MM/d, hh:mm a").format(reminderDateTime!),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: widget.isCompleted
                            ? listViewCompletedTextColor
                            : textColor,
                        decoration: widget.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ],
                ),
            ],
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
}
