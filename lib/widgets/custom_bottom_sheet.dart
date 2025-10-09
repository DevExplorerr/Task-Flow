// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/widgets/colors.dart';
import 'custom_button.dart';
import 'custom_textfield.dart';

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
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
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    reminder(context),
                    const SizedBox(width: 10),
                    CustomButton(
                      buttonColor: primaryButtonColor,
                      buttonText: widget.buttonText,
                      buttonTextColor: primaryButtonTextColor,
                      fontSize: 14.sp,
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
    return GestureDetector(
      onTap: () => _showDateTimePicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
            color: blackColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r)),
        child: Row(children: [
          const Icon(Icons.alarm, color: blackColor, size: 20),
          const SizedBox(width: 5),
          Text(
            _selectedDateTime != null
                ? DateFormat("MM/d, hh:mm a").format(_selectedDateTime!)
                : "Add Reminder",
            style: GoogleFonts.poppins(
                color: textColor, fontWeight: FontWeight.w500, fontSize: 12.sp),
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
                  child: const Icon(Icons.cancel, color: blackColor),
                )
              : const SizedBox.shrink()
        ]),
      ),
    );
  }

  void _showDateTimePicker(BuildContext context) {
    DateTime selectedDateTime = _selectedDateTime ?? DateTime.now();

    showModalBottomSheet(
      context: context,
      elevation: 10,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(18.r),
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
                    horizontal: kToolbarHeight, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.redAccent,
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
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: primaryButtonColor,
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
