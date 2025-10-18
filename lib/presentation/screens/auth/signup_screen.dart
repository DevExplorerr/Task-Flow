// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/global/snackbar.dart';
import 'package:task_management_app/logic/services/auth_service.dart';
import 'package:task_management_app/presentation/screens/auth/login_screen.dart';
import 'package:task_management_app/core/constants/app_colors.dart';
import 'package:task_management_app/presentation/screens/home/home_screen.dart';
import 'package:task_management_app/presentation/widgets/buttons/custom_button.dart';
import 'package:task_management_app/presentation/widgets/forms/custom_textfield.dart';

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

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = "Please fill in all fields.");
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await authservice.value.signUp(
        email: email,
        password: password,
        userName: username,
      );

      showFloatingSnackBar(
        context,
        message: "Registration successful",
        backgroundColor: AppColors.success,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'email-already-in-use') {
        message = "The email address is already in use.";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email format.";
      } else if (e.code == 'weak-password') {
        message = "Password should be at least 6 characters.";
      } else {
        message = "Error: ${e.message ?? e.code}";
      }

      showFloatingSnackBar(
        context,
        message: message,
        backgroundColor: AppColors.error,
      );
    } catch (_) {
      showFloatingSnackBar(
        context,
        message: "Unexpected error occurred. Please try again later.",
        backgroundColor: AppColors.error,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
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
                    ),
                  ),
                  Positioned(
                    top: 60,
                    right: 20,
                    child: CustomButton(
                      height: 40,
                      width: 122,
                      buttonText: 'SIGN IN',
                      fontSize: 17,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Form Section
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "New User? Get Started Now",
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 35),
                    CustomTextfield(
                      hintText: "Enter username",
                      controller: _usernameController,
                      text: "User Name",
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 20),
                    CustomTextfield(
                      hintText: "Enter email",
                      controller: _emailController,
                      text: "Email",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
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
                          color: theme.iconTheme.color,
                        ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: theme.primaryColor,
                                  strokeWidth: 5,
                                ),
                              )
                            : CustomButton(
                                height: 50,
                                width: 140,
                                buttonText: "SIGN UP",
                                fontSize: 22,
                                onPressed: () => _register(),
                              ),
                        CustomButton(
                          height: 50,
                          width: 140,
                          buttonText: 'Generate',
                          fontSize: 22,
                          onPressed: () => _generatePassword(),
                        ),
                      ],
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
