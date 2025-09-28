// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/widgets/colors.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () async {
      await Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/images/header.png",
            height: 180.h,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              children: [
                Text(
                  "Task Flow",
                  style: GoogleFonts.akayaTelivigala(
                    fontSize: 30.sp,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 25.h),
                Image.asset(
                  "assets/app_logo.png",
                  height: 220.h,
                  width: 239.w,
                ),
                SizedBox(height: 35.h),
                const CircularProgressIndicator(
                  color: blackColor,
                )
              ],
            ),
          ),
          Image.asset(
            "assets/images/footer.png",
            height: 180.h,
            width: double.infinity,
            fit: BoxFit.fill,
          )
        ],
      ),
    );
  }
}
