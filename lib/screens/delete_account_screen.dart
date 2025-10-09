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

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obsecureText = true;
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
    passwordController.dispose();
    super.dispose();
  }

  Future<void> deleteAccount() async {
    try {
      setState(() {
        isLoading = true;
      });

      await authservice.value.deleteAccount(
        email: emailController.text,
        password: passwordController.text,
      );
      showFloatingSnackBar(context,
          message: "Account deleted successfully",
          backgroundColor: successColor);

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      showFloatingSnackBar(context,
          message: e.message.toString(), backgroundColor: errorColor);
      setState(() {
        isLoading = false;
      });
    }
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Icon(
                      Icons.delete_forever,
                      size: 80,
                      color: inputIconColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Delete my account",
                    style: GoogleFonts.poppins(
                      color: blackColor,
                      fontSize: 28.sp,
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
                    hintText: 'Enter your password',
                    text: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    obsecureText: obsecureText,
                    controller: passwordController,
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
                  const SizedBox(height: 35),
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: blackColor, strokeWidth: 5),
                        )
                      : CustomButton(
                          onPressed: () async {
                            await deleteAccount();
                          },
                          height: 50.h,
                          width: double.infinity,
                          fontSize: 22.sp,
                          buttonColor: primaryButtonColor,
                          buttonText: 'Delete Permanently',
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
