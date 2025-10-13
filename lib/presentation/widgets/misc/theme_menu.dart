import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/core/constants/app_colors.dart';

class ThemeMenu extends StatelessWidget {
  final Function(String) onThemeSelected;
  const ThemeMenu({super.key, required this.onThemeSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.only(
          left: 20,
          top: 10,
          bottom: 10,
          right: 5,
        ),
        decoration: BoxDecoration(
          color: bottomSheetbgColor,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.light_mode,
              color: inputIconColor,
              size: 22,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                "Theme",
                style: GoogleFonts.rubik(color: textColor),
              ),
            ),
            PopupMenuButton<String>(
              color: whiteColor,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              icon: const Icon(
                Icons.more_vert,
                color: blackColor,
              ),
              onSelected: onThemeSelected,
              itemBuilder: (context) {
                return [
                  _buildMenuItem(
                    Icons.brightness_medium_outlined,
                    "System (Default)",
                    'system',
                  ),
                  _buildMenuItem(
                    Icons.light_mode,
                    "Light",
                    'light',
                  ),
                  _buildMenuItem(
                    Icons.dark_mode,
                    "Dark",
                    'dark',
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(
      IconData icon, String text, String value) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: inputIconColor),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
