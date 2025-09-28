// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/screens/reset_password_screen.dart';
import 'package:task_management_app/service/auth_service.dart';
import 'package:task_management_app/screens/signup_screen.dart';
import 'package:task_management_app/widgets/colors.dart';
import 'package:task_management_app/global/toast.dart';
import 'package:task_management_app/screens/home_screen.dart';
import 'package:task_management_app/widgets/custom_button.dart';
import 'package:task_management_app/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isobscureText = true;
  bool isLoading = false;
  String errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (_emailController.text.trim().isEmpty ||
          _passwordController.text.trim().isEmpty) {
        setState(() {
          errorMessage = "Please enter email and password";
        });
        setState(() {
          isLoading = false;
        });
      }

      await authservice.value.login(
          email: _emailController.text, password: _passwordController.text);
      showToast(message: "Login successfully");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: "Invalid email or password.");
      } else {
        showToast(message: "Error: ${e.code}");
      }
    } catch (e) {
      showToast(message: "Unexpected error occurred.");
    }

    setState(() => isLoading = false);
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
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()),
                        );
                      },
                      height: 40.h,
                      width: 130.w,
                      buttonColor: secondaryButtonColor,
                      buttonText: 'SIGN UP',
                      buttonTextColor: secondaryButtonTextColor,
                      fontSize: 17.sp,
                    ),
                  ),
                ],
              ),

              // Form Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                child: Column(
                  children: [
                    SizedBox(height: 5.h),
                    Text(
                      "Sign In To Continue",
                      style: GoogleFonts.poppins(
                        color: textColor,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 35.h),
                    CustomTextfield(
                      text: "Email",
                      hintText: 'Enter your email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20.h),
                    CustomTextfield(
                      text: "Password",
                      hintText: 'Enter your password',
                      controller: _passwordController,
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
                    SizedBox(height: 10.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ResetPassword(),
                            ),
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
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
                    isLoading
                        ? Center(
                            child: const CircularProgressIndicator(
                                color: blackColor, strokeWidth: 5),
                          )
                        : CustomButton(
                            onPressed: () async {
                              await _login();
                            },
                            height: 50.h,
                            width: double.infinity,
                            buttonColor: primaryButtonColor,
                            buttonText: 'SIGN IN',
                            buttonTextColor: primaryButtonTextColor,
                            fontSize: 22.sp,
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
