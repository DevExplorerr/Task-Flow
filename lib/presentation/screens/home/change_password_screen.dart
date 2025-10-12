// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/global/snackbar.dart';
import 'package:task_management_app/presentation/screens/home/home_screen.dart';
import 'package:task_management_app/logic/services/auth_service.dart';
import 'package:task_management_app/core/constants/app_colors.dart';
import 'package:task_management_app/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:task_management_app/presentation/widgets/buttons/custom_button.dart';
import 'package:task_management_app/presentation/widgets/forms/custom_textfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with SingleTickerProviderStateMixin {
  bool obsecureText = true;
  bool obsecuretext = true;
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
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

  Future<void> updatePassword() async {
    if (emailController.text.isEmpty ||
        currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty) {
      showFloatingSnackBar(
        context,
        message: "Please fill all fields",
        backgroundColor: errorColor,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await authservice.value.resetPasswordWithCurrentPassword(
        currentPassword: currentPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
        email: emailController.text.trim(),
      );

      if (!mounted) return;
      showFloatingSnackBar(
        context,
        message: "Password Changed Successfully",
        backgroundColor: successColor,
      );

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showFloatingSnackBar(
        context,
        message: e.message ?? "Password Change Failed",
        backgroundColor: errorColor,
      );
    } catch (e) {
      if (!mounted) return;
      showFloatingSnackBar(
        context,
        message: "An unexpected error occurred",
        backgroundColor: errorColor,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    newPasswordController.dispose();
    currentPasswordController.dispose();
    super.dispose();
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
                    child:
                        const Icon(Icons.lock, size: 80, color: inputIconColor),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Change Password",
                    style: GoogleFonts.poppins(
                      color: blackColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomTextfield(
                    hintText: "Email",
                    text: "Enter your email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 25),
                  CustomTextfield(
                    hintText: "Current Password",
                    text: "Enter current password",
                    controller: currentPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    obsecureText: obsecureText,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecureText = !obsecureText;
                        });
                      },
                      icon: Icon(
                        obsecureText ? Icons.visibility_off : Icons.visibility,
                        color: blackColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  CustomTextfield(
                    hintText: "New Password",
                    text: "Enter new password",
                    controller: newPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    obsecureText: obsecuretext,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecuretext = !obsecuretext;
                        });
                      },
                      icon: Icon(
                        obsecuretext ? Icons.visibility_off : Icons.visibility,
                        color: blackColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: blackColor, strokeWidth: 5),
                        )
                      : CustomButton(
                          onPressed: () => updatePassword(),
                          height: 50.h,
                          width: double.infinity,
                          fontSize: 22.sp,
                          buttonColor: primaryButtonColor,
                          buttonText: 'Change Password',
                          buttonTextColor: primaryButtonTextColor,
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
