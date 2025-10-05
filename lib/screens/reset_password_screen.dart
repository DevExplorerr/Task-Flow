// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/global/snackbar.dart';
import 'package:task_management_app/screens/login_screen.dart';
import 'package:task_management_app/services/auth_service.dart';
import 'package:task_management_app/widgets/colors.dart';
import 'package:task_management_app/widgets/custom_button.dart';
import 'package:task_management_app/widgets/custom_textfield.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      await authservice.value.resetPassword(email: emailController.text);
      showFloatingSnackBar(context,
          message: "Reset link sent check your email",
          backgroundColor: successColor);

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      });
    } on FirebaseAuthException catch (e) {
      showFloatingSnackBar(context,
          message: e.message ?? "An error occured",
          backgroundColor: errorColor);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: blackColor),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 25.h),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Icon(
                      Icons.lock_outline,
                      size: 80.sp,
                      color: blackColor,
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Text(
                    "Reset Password",
                    style: GoogleFonts.poppins(
                      color: textColor,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Enter your email to receive a reset link",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: listViewTextColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 35.h),
                  CustomTextfield(
                    hintText: "Email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    text: 'Reset Password',
                  ),
                  SizedBox(height: 40.h),
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: blackColor))
                      : CustomButton(
                          buttonColor: primaryButtonColor,
                          buttonText: "Reset Password",
                          buttonTextColor: whiteColor,
                          height: 48.h,
                          width: double.infinity,
                          fontSize: 16.sp,
                          onPressed: () async {
                            await resetPassword();
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
