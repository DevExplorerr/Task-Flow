// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/global/snackbar.dart';
import 'package:task_management_app/screens/reset_password_screen.dart';
import 'package:task_management_app/services/auth_service.dart';
import 'package:task_management_app/screens/signup_screen.dart';
import 'package:task_management_app/widgets/colors.dart';
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
      showFloatingSnackBar(context,
          message: "Login successfully", backgroundColor: successColor);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showFloatingSnackBar(context,
            message: "Invalid email or password.", backgroundColor: errorColor);
      } else {
        showFloatingSnackBar(context,
            message: "Error: ${e.code}", backgroundColor: errorColor);
      }
    } catch (e) {
      showFloatingSnackBar(context,
          message: "Unexpected error occurred.", backgroundColor: errorColor);
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "Sign In To Continue",
                      style: GoogleFonts.poppins(
                        color: textColor,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 35),
                    CustomTextfield(
                      text: "Email",
                      hintText: 'Enter your email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 10),
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
                              style: GoogleFonts.poppins(color: errorColor),
                            ),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(height: 45),
                    isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
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
                    const SizedBox(height: 20),
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
