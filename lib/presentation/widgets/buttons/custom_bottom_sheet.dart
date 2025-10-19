// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/core/constants/app_colors.dart';
import 'custom_button.dart';
import '../forms/custom_textfield.dart';

class CustomBottomSheet extends StatefulWidget {
  final String hintText;
  final String text;
  final String buttonText;
  final VoidCallback onPressed;
  final TextEditingController controller;
  final ValueChanged<DateTime?> onReminderSelected;
  final DateTime? initialReminder;

  const CustomBottomSheet({
    super.key,
    required this.hintText,
    required this.text,
    required this.buttonText,
    required this.onPressed,
    required this.controller,
    required this.onReminderSelected,
    this.initialReminder,
  });

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialReminder;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
            decoration: BoxDecoration(
              color: theme.bottomSheetTheme.backgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                CustomTextfield(
                  hintText: widget.hintText,
                  controller: widget.controller,
                  text: widget.text,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  autoFocus: true,
                  textInputAction: TextInputAction.newline,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    reminder(context),
                    const SizedBox(width: 10),
                    CustomButton(
                      buttonText: widget.buttonText,
                      fontSize: 14,
                      onPressed: () {
                        widget.onPressed();
                        widget.onReminderSelected(_selectedDateTime);
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

  Widget reminder(BuildContext context) {
    final theme = Theme.of(context);
    final reminderBgColor = theme.brightness == Brightness.dark
        ? AppColors.white.withOpacity(0.1)
        : AppColors.black.withOpacity(0.1);
    return GestureDetector(
      onTap: () => _showDateTimePicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: reminderBgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.alarm, color: theme.iconTheme.color, size: 20),
            const SizedBox(width: 5),
            Text(
              _selectedDateTime != null
                  ? DateFormat("MM/d, hh:mm a").format(_selectedDateTime!)
                  : "Add Reminder",
              style: theme.textTheme.labelSmall,
            ),
            const SizedBox(width: 8),
            _selectedDateTime != null
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDateTime = null;
                      });
                      widget.onReminderSelected(null);
                    },
                    child: Icon(Icons.cancel, color: theme.iconTheme.color),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  void _showDateTimePicker(BuildContext context) {
    DateTime selectedDateTime = _selectedDateTime ?? DateTime.now();
    final theme = Theme.of(context);
    final dateTimePickerColor = theme.brightness == Brightness.dark
        ? AppColors.primary
        : AppColors.white;
    final textButtonColor = theme.brightness == Brightness.dark
        ? AppColors.secondary
        : AppColors.primary;

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: dateTimePickerColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 250.h,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: _selectedDateTime ?? DateTime.now(),
                  use24hFormat: false,
                  onDateTimeChanged: (DateTime newDateTime) {
                    selectedDateTime = newDateTime;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kToolbarHeight,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedDateTime = selectedDateTime;
                        });
                        widget.onReminderSelected(_selectedDateTime);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Done",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textButtonColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
