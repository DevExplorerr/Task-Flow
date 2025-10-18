// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/global/snackbar.dart';
import 'package:task_management_app/presentation/screens/auth/reset_password_screen.dart';
import 'package:task_management_app/logic/services/auth_service.dart';
import 'package:task_management_app/presentation/screens/auth/signup_screen.dart';
import 'package:task_management_app/core/constants/app_colors.dart';
import 'package:task_management_app/presentation/screens/home/home_screen.dart';
import 'package:task_management_app/presentation/widgets/buttons/custom_button.dart';
import 'package:task_management_app/presentation/widgets/forms/custom_textfield.dart';

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
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      setState(() => errorMessage = "Please enter email and password");
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await authservice.value.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      showFloatingSnackBar(
        context,
        message: "Login successfully",
        backgroundColor: AppColors.success,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        message = "Invalid email or password.";
      } else {
        message = "Error: ${e.message ?? e.code}";
      }
      showFloatingSnackBar(
        context,
        message: message,
        backgroundColor: AppColors.error,
      );
    } catch (e) {
      showFloatingSnackBar(
        context,
        message: "Unexpected error occurred.",
        backgroundColor: AppColors.error,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    child: Image.asset(
                      'assets/images/header.png',
                      width: double.infinity,
                      height: 265,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  Positioned(
                    top: 60,
                    right: 20,
                    child: CustomButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      height: 40,
                      width: 130,
                      buttonText: 'SIGN UP',
                      fontSize: 17,
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
                      style: theme.textTheme.headlineMedium,
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
                          color: theme.iconTheme.color,
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
                        child: Text("Forgot Password?",
                            style: theme.textTheme.titleSmall),
                      ),
                    ),
                    errorMessage.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              errorMessage,
                              style:
                                  GoogleFonts.poppins(color: AppColors.error),
                            ),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(height: 45),
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: theme.primaryColor,
                              strokeWidth: 5,
                            ),
                          )
                        : CustomButton(
                            onPressed: () => _login(),
                            height: 50,
                            width: double.infinity,
                            buttonText: 'SIGN IN',
                            fontSize: 22,
                          ),
                    const SizedBox(height: 20),
                    Text(
                      "Terms and Conditions | Privacy Policy",
                      style: theme.textTheme.labelSmall,
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
