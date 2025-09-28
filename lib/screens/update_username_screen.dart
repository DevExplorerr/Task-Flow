import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/global/toast.dart';
import 'package:task_management_app/screens/home_screen.dart';
import 'package:task_management_app/service/auth_service.dart';
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
        showToast(message: "Username Changed Successfully");
        navigateToHomeScreen();
      } else {
        showToast(message: "Please enter a valid username");
      }
    } catch (e) {
      showToast(message: "Username Change Failed");
      setState(() {
        isLoading = false;
      });
    }
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
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 25.h),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Icon(
                      Icons.text_fields,
                      size: 80.sp,
                      color: inputIconColor,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Update username",
                    style: GoogleFonts.poppins(
                      color: blackColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  CustomTextfield(
                    hintText: "Enter new username",
                    text: "User Name",
                    controller: userNameController,
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 35.h),
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
