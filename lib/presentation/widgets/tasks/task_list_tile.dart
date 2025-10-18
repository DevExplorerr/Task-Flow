// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/presentation/widgets/buttons/custom_bottom_sheet.dart';
import '../../../core/constants/app_colors.dart';

class TaskListTile extends StatefulWidget {
  final String taskTitle;
  final VoidCallback onDelete;
  final void Function(String newTitle, DateTime? newReminder) onEdit;
  final bool isCompleted;
  final ValueChanged<bool> onStatusToggle;
  DateTime? reminderDateTime;
  TaskListTile({
    super.key,
    required this.taskTitle,
    required this.onDelete,
    required this.onEdit,
    required this.isCompleted,
    required this.onStatusToggle,
    this.reminderDateTime,
  });

  @override
  State<TaskListTile> createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  void _openEditTaskBottomSheet() {
    final editController = TextEditingController(text: widget.taskTitle);
    final theme = Theme.of(context);
    showModalBottomSheet(
      elevation: 10,
      backgroundColor: theme.bottomSheetTheme.backgroundColor,
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => CustomBottomSheet(
        hintText: 'Edit your task...',
        text: 'Edit Task',
        buttonText: 'Save',
        controller: editController,
        initialReminder: widget.reminderDateTime,
        onPressed: () {
          if (editController.text.trim().isNotEmpty) {
            widget.onEdit(editController.text.trim(), widget.reminderDateTime);
            Navigator.pop(context);
          }
        },
        onReminderSelected: (dateTime) {
          setState(() {
            widget.reminderDateTime = dateTime;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightnessCheck = theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
        ),
        child: ListTile(
          minTileHeight: 40,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 10,
          ),
          title: GestureDetector(
            onTap: () => _openEditTaskBottomSheet(),
            child: AnimatedScale(
              scale: widget.isCompleted ? 0.97 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: widget.isCompleted ? 0.7 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.taskTitle,
                      style: GoogleFonts.poppins(
                        color: widget.isCompleted
                            ? AppColors.listCompletedText
                            : brightnessCheck
                                ? AppColors.textDark
                                : AppColors.listText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: widget.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    if (widget.reminderDateTime != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          widget.isCompleted
                              ? const SizedBox.shrink()
                              : const Icon(
                                  Icons.alarm,
                                  color: AppColors.error,
                                  size: 20,
                                ),
                          const SizedBox(width: 5),
                          Text(
                            DateFormat("MM/d, hh:mm a")
                                .format(widget.reminderDateTime!),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: widget.isCompleted
                                  ? AppColors.listCompletedText
                                  : brightnessCheck
                                      ? AppColors.textDark
                                      : AppColors.textLight,
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
            ),
          ),
          leading: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: IconButton(
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
                    ? brightnessCheck
                        ? AppColors.secondary
                        : AppColors.primary
                    : AppColors.listUncheck,
                size: 28.sp,
              ),
            ),
          ),
          trailing: IconButton(
            onPressed: widget.onDelete,
            icon: const Icon(
              Icons.close_sharp,
              color: AppColors.listDeleteIcon,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
