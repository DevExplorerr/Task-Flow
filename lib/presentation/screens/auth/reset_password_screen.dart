// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/global/snackbar.dart';
import 'package:task_management_app/presentation/screens/auth/login_screen.dart';
import 'package:task_management_app/logic/services/auth_service.dart';
import 'package:task_management_app/core/constants/app_colors.dart';
import 'package:task_management_app/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:task_management_app/presentation/widgets/buttons/custom_button.dart';
import 'package:task_management_app/presentation/widgets/forms/custom_textfield.dart';

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
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showFloatingSnackBar(
        context,
        message: "Please enter your email address.",
        backgroundColor: errorColor,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await authservice.value.resetPassword(email: email);

      showFloatingSnackBar(
        context,
        message: "Reset link sent! Check your email.",
        backgroundColor: successColor,
      );

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      showFloatingSnackBar(
        context,
        message: e.message ?? "An error occurred. Please try again.",
        backgroundColor: errorColor,
      );
    } catch (_) {
      showFloatingSnackBar(
        context,
        message: "Unexpected error occurred. Try again later.",
        backgroundColor: errorColor,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: const CustomAppBar(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Icon(
                      Icons.lock_outline,
                      size: 80,
                      color: blackColor,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Reset Password",
                    style: GoogleFonts.poppins(
                      color: textColor,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter your email to receive a reset link",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: listViewTextColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  const SizedBox(height: 35),
                  CustomTextfield(
                    hintText: "Email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    text: 'Reset Password',
                  ),
                  const SizedBox(height: 40),
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
                          onPressed: () => resetPassword(),
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
