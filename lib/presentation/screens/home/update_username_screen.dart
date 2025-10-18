// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:task_management_app/global/snackbar.dart';
import 'package:task_management_app/presentation/screens/home/home_screen.dart';
import 'package:task_management_app/logic/services/auth_service.dart';
import 'package:task_management_app/core/constants/app_colors.dart';
import 'package:task_management_app/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:task_management_app/presentation/widgets/buttons/custom_button.dart';
import 'package:task_management_app/presentation/widgets/forms/custom_textfield.dart';

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
    final newUsername = userNameController.text.trim();

    if (newUsername.isEmpty) {
      showFloatingSnackBar(
        context,
        message: "Please enter a valid username",
        backgroundColor: AppColors.error,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authservice.value.updateUsername(userName: newUsername);

      showFloatingSnackBar(
        context,
        message: "Username changed successfully",
        backgroundColor: AppColors.success,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      showFloatingSnackBar(
        context,
        message: "Username change failed. Please try again.",
        backgroundColor: AppColors.error,
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
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
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
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
                    child: Icon(
                      Icons.text_fields,
                      size: 80,
                      color: theme.iconTheme.color,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Update Username",
                    style: theme.textTheme.headlineLarge,
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
                      ? Center(
                          child: CircularProgressIndicator(
                            color: theme.primaryColor,
                            strokeWidth: 5,
                          ),
                        )
                      : CustomButton(
                          onPressed: () => updateUsername(),
                          buttonText: 'Update Username',
                          fontSize: 22,
                          height: 50,
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
