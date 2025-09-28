import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/widgets/colors.dart';

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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          backgroundColor: bottomSheetbgColor,
        ),
        onPressed: press,
        child: Row(
          children: [
            Icon(icon, color: inputIconColor, size: 22.sp),
            SizedBox(width: 20.w),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.rubik(color: textColor),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: blackColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
