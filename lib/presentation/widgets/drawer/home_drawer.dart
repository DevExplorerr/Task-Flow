// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/global/snackbar.dart';
import 'package:task_management_app/presentation/screens/home/change_password_screen.dart';
import 'package:task_management_app/presentation/screens/home/delete_account_screen.dart';
import 'package:task_management_app/presentation/screens/auth/login_screen.dart';
import 'package:task_management_app/presentation/screens/home/settings_screen.dart';
import 'package:task_management_app/presentation/screens/home/update_username_screen.dart';
import 'package:task_management_app/logic/services/auth_service.dart';
import 'package:task_management_app/core/constants/app_colors.dart';
import 'package:task_management_app/presentation/widgets/dialog/custom_confirmation_dialogbox.dart';
import 'package:task_management_app/presentation/widgets/misc/menu.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  void logout() async {
    try {
      await authservice.value.logout();

      if (!mounted) return;
      Navigator.pop(context);

      showFloatingSnackBar(
        context,
        message: "Logged out successfully",
        backgroundColor: AppColors.success,
      );

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showFloatingSnackBar(
        context,
        message: e.message.toString(),
        backgroundColor: AppColors.error,
      );
    } catch (e) {
      if (!mounted) return;
      showFloatingSnackBar(
        context,
        message: "An unexpected error occurred.",
        backgroundColor: AppColors.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final drawerHeader = theme.brightness == Brightness.dark
        ? AppColors.black
        : AppColors.primary;
    return Padding(
      padding: const EdgeInsets.only(left: 90),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: drawerHeader),
              child: Center(
                child: Text(
                  'Menu',
                  style: GoogleFonts.poppins(
                    color: AppColors.secondary,
                    fontSize: 22,
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
                          onPressed: () => logout(),
                        ),
                      );
                    }),
                Menu(
                    text: 'General',
                    icon: Icons.settings,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
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
