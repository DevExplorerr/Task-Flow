import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/global/toast.dart';
import 'package:task_management_app/screens/home_screen.dart';
import 'package:task_management_app/service/auth_service.dart';
import 'package:task_management_app/widgets/colors.dart';
import 'package:task_management_app/widgets/custom_button.dart';
import 'package:task_management_app/widgets/custom_textfield.dart';

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
    try {
      setState(() {
        isLoading = true;
      });
      await authservice.value.resetPasswordWithCurrentPassword(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        email: emailController.text,
      );
      showToast(message: "Password Changed Successfully");
      navigateToHomeScreen();
    } catch (e) {
      showToast(message: "Password Change Failed");
    }
    setState(() {
      isLoading = false;
    });
  }

  void navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
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
                    child: Icon(Icons.lock, size: 80.sp, color: inputIconColor),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Change Password",
                    style: GoogleFonts.poppins(
                      color: blackColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  CustomTextfield(
                    hintText: "Email",
                    text: "Enter your email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 25.h),
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
                  SizedBox(height: 25.h),
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
                  SizedBox(height: 35.h),
                  isLoading
                      ? Center(
                          child: const CircularProgressIndicator(
                              color: blackColor, strokeWidth: 5),
                        )
                      : CustomButton(
                          onPressed: () async {
                            await updatePassword();
                          },
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
