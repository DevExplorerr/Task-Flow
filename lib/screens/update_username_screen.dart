// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/global/snackbar.dart';
import 'package:task_management_app/screens/home_screen.dart';
import 'package:task_management_app/services/auth_service.dart';
import 'package:task_management_app/widgets/colors.dart';
import 'package:task_management_app/widgets/custom_button.dart';
import 'package:task_management_app/widgets/custom_textfield.dart';

class UpdateUsernameScreen extends StatefulWidget {
  const UpdateUsernameScreen({super.key});

  @override
  State<UpdateUsernameScreen> createState() => _UpdateUsernameScreenState();
}

class _UpdateUsernameScreenState extends State<UpdateUsernameScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController userNameController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool isLoading = false;

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

  Future<void> updateUsername() async {
    try {
      setState(() {
        isLoading = true;
      });
      await authservice.value.updateUsername(userName: userNameController.text);
      if (userNameController.text.isNotEmpty) {
        showFloatingSnackBar(context,
            message: "Username Changed Successfully",
            backgroundColor: successColor);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        showFloatingSnackBar(context,
            message: "Please enter a valid username",
            backgroundColor: errorColor);
      }
    } catch (e) {
      showFloatingSnackBar(context,
          message: "Username Change Failed", backgroundColor: errorColor);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    userNameController.dispose();
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Icon(
                      Icons.text_fields,
                      size: 80,
                      color: inputIconColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Update username",
                    style: GoogleFonts.poppins(
                      color: blackColor,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomTextfield(
                    hintText: "Enter new username",
                    text: "User Name",
                    controller: userNameController,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 35),
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: blackColor, strokeWidth: 5),
                        )
                      : CustomButton(
                          onPressed: () async {
                            await updateUsername();
                          },
                          buttonColor: primaryButtonColor,
                          buttonText: 'Update Username',
                          buttonTextColor: primaryButtonTextColor,
                          fontSize: 22.sp,
                          height: 50.h,
                          width: double.infinity,
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
