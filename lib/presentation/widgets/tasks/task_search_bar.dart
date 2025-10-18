import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/core/constants/app_colors.dart';

class TaskSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  const TaskSearchBar({super.key, required this.onSearchChanged});

  @override
  State<TaskSearchBar> createState() => _TaskSearchBarState();
}

class _TaskSearchBarState extends State<TaskSearchBar> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightnessCheck = theme.brightness == Brightness.dark;
    final fillColor = brightnessCheck ? AppColors.primary : AppColors.white;
    final enabledBorderSide =
        brightnessCheck ? AppColors.black : AppColors.inputBorder;
    final focusedBorderSide =
        brightnessCheck ? AppColors.white : AppColors.black;
    final inputTextColor =
        brightnessCheck ? AppColors.textDark : AppColors.textLight;
    return TextField(
      controller: searchController,
      onChanged: widget.onSearchChanged,
      style: GoogleFonts.podkova(color: inputTextColor),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
        hintText: 'Search task',
        hintStyle: GoogleFonts.podkova(
          color: AppColors.inputHint,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        suffixIcon: Icon(
          Icons.search,
          color: theme.inputDecorationTheme.iconColor,
        ),
        filled: true,
        fillColor: fillColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: enabledBorderSide),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: focusedBorderSide),
        ),
      ),
    );
  }
}
