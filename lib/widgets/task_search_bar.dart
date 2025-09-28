import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/widgets/add_task_button.dart';
import 'package:task_management_app/widgets/colors.dart';

class TaskSearchBar extends StatefulWidget {
  final Function(String) onAddTask;
  final Function(String) onSearchChanged;
  const TaskSearchBar(
      {super.key, required this.onAddTask, required this.onSearchChanged});

  @override
  State<TaskSearchBar> createState() => _TaskSearchBarState();
}

class _TaskSearchBarState extends State<TaskSearchBar> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            onChanged: widget.onSearchChanged,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14.0.h, horizontal: 16.0.w),
              hintText: 'Search task',
              hintStyle: GoogleFonts.podkova(
                color: inputHintTextColor,
                fontSize: 17.sp,
              ),
              suffixIcon: const Icon(Icons.search, color: inputIconColor),
              filled: true,
              fillColor: bgColor,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: inputBorderColor),
                borderRadius: BorderRadius.circular(8.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: blackColor),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            style: GoogleFonts.podkova(color: textColor),
          ),
        ),
        SizedBox(width: 12.w),
        AddTaskButton(
          onAddTask: widget.onAddTask,
        ),
      ],
    );
  }
}
