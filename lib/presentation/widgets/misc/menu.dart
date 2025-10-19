import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/core/constants/app_colors.dart';

class Menu extends StatelessWidget {
  const Menu({
    super.key,
    required this.text,
    required this.icon,
    this.press,
  });

  final String text;
  final IconData icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor =
        theme.brightness == Brightness.dark ? AppColors.white : AppColors.black;
    final bgColor = theme.brightness == Brightness.dark
        ? AppColors.primary
        : AppColors.secondary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: bgColor,
        ),
        onPressed: press,
        child: Row(
          children: [
            Icon(icon, color: theme.iconTheme.color, size: 22),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.rubik(color: textColor),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: theme.iconTheme.color,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
