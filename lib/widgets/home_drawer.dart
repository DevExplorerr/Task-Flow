// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/global/toast.dart';
import 'package:task_management_app/screens/change_password_screen.dart';
import 'package:task_management_app/screens/delete_account_screen.dart';
import 'package:task_management_app/screens/login_screen.dart';
import 'package:task_management_app/screens/update_username_screen.dart';
import 'package:task_management_app/services/auth_service.dart';
import 'package:task_management_app/widgets/colors.dart';
import 'package:task_management_app/widgets/custom_confirmation_dialogbox.dart';
import 'package:task_management_app/widgets/menu.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  void navigateToLoginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void logout() async {
    try {
      await authservice.value.logout();
      showToast(message: "Logged out successfully");
      Navigator.pop(context);
      await Future.delayed(const Duration(seconds: 1));
      navigateToLoginScreen();
    } on FirebaseAuthException catch (e) {
      showToast(message: e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 90.w),
      child: Drawer(
        backgroundColor: bgColor,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(16.r)),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: primaryButtonColor),
              child: Center(
                child: Text(
                  'Menu',
                  style: GoogleFonts.poppins(
                    color: primaryButtonTextColor,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Menu(
                    text: 'Update Username',
                    icon: Icons.person,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const UpdateUsernameScreen(),
                        ),
                      );
                    }),
                Menu(
                    text: 'Update Password',
                    icon: Icons.lock,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChangePasswordScreen(),
                        ),
                      );
                    }),
                Menu(
                    text: 'Delete Account',
                    icon: Icons.delete_forever,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DeleteAccountScreen(),
                        ),
                      );
                    }),
                Menu(
                    text: 'Logout',
                    icon: Icons.logout,
                    press: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        animationStyle: AnimationStyle(
                          curve: Curves.easeInQuart,
                          duration: const Duration(milliseconds: 300),
                          reverseDuration: const Duration(milliseconds: 200),
                        ),
                        builder: (context) => CustomConfirmationDialogbox(
                          title: "Are you sure you want to logout?",
                          buttonText: "Logout",
                          onPressed: () {
                            logout();
                          },
                        ),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
