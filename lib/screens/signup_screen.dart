// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/service/auth_service.dart';
import 'package:task_management_app/screens/login_screen.dart';
import 'package:task_management_app/widgets/colors.dart';
import 'package:task_management_app/screens/home_screen.dart';
import 'package:task_management_app/widgets/custom_button.dart';
import 'package:task_management_app/widgets/custom_textfield.dart';
import '../global/toast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isobscureText = true;
  bool isLoading = false;
  String errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      setState(() {
        isLoading = true;
      });
      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        setState(() {
          errorMessage = "Please fill in all fields.";
        });
        setState(() {
          isLoading = false;
        });
      }

      await authservice.value.signUp(
          email: _emailController.text,
          password: _passwordController.text,
          userName: _usernameController.text);
      showToast(message: "Registration successful");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: "The email address is already in use.");
      } else {
        showToast(message: "Error: ${e.code}");
      }
    } catch (e) {
      showToast(message: "Unexpected error occurred.");
    }
    setState(() {
      isLoading = false;
    });
  }

  String generateRandomPassword({int length = 8}) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()';
    Random random = Random.secure();

    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  void _generatePassword() {
    String newPassword = generateRandomPassword();
    _passwordController.text = newPassword;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: bgColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    child: Image.asset(
                      'assets/images/header.png',
                      width: double.infinity,
                      height: 265.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 60.h,
                    right: 20.w,
                    child: CustomButton(
                      height: 40.h,
                      width: 122.w,
                      buttonColor: secondaryButtonColor,
                      buttonText: 'SIGN IN',
                      buttonTextColor: secondaryButtonTextColor,
                      fontSize: 17.sp,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Form Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
                child: Column(
                  children: [
                    SizedBox(height: 5.h),
                    Text(
                      "New User? Get Started Now",
                      style: GoogleFonts.poppins(
                        color: textColor,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 35.h),
                    CustomTextfield(
                      hintText: "Enter username",
                      controller: _usernameController,
                      text: "User Name",
                      keyboardType: TextInputType.name,
                    ),
                    SizedBox(height: 20.h),
                    CustomTextfield(
                        hintText: "Enter email",
                        controller: _emailController,
                        text: "Email",
                        keyboardType: TextInputType.emailAddress),
                    SizedBox(height: 20.h),
                    CustomTextfield(
                      hintText: "Enter password",
                      controller: _passwordController,
                      text: "Password",
                      keyboardType: TextInputType.visiblePassword,
                      obsecureText: isobscureText,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isobscureText = !isobscureText;
                          });
                        },
                        icon: Icon(
                          isobscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: blackColor,
                        ),
                      ),
                    ),
                    errorMessage.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Text(
                              errorMessage,
                              style: GoogleFonts.poppins(color: Colors.red),
                            ),
                          )
                        : const SizedBox.shrink(),
                    SizedBox(height: 45.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        isLoading
                            ? Center(
                                child: const CircularProgressIndicator(
                                    color: blackColor, strokeWidth: 5),
                              )
                            : CustomButton(
                                height: 50.h,
                                width: 160.w,
                                buttonColor: primaryButtonColor,
                                buttonText: "SIGN UP",
                                buttonTextColor: primaryButtonTextColor,
                                fontSize: 22.sp,
                                onPressed: () async {
                                  await _register();
                                },
                              ),
                        CustomButton(
                          height: 50.h,
                          width: 160.w,
                          buttonColor: primaryButtonColor,
                          buttonText: 'Generate',
                          buttonTextColor: primaryButtonTextColor,
                          fontSize: 24.sp,
                          onPressed: () {
                            _generatePassword();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Terms and Conditions | Privacy Policy",
                      style: GoogleFonts.poppins(
                        color: textColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
