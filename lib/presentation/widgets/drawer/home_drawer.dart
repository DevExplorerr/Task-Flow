// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/global/snackbar.dart';
import 'package:task_management_app/logic/provider/theme_provider.dart';
import 'package:task_management_app/presentation/screens/home/change_password_screen.dart';
import 'package:task_management_app/presentation/screens/home/delete_account_screen.dart';
import 'package:task_management_app/presentation/screens/auth/login_screen.dart';
import 'package:task_management_app/presentation/screens/home/update_username_screen.dart';
import 'package:task_management_app/logic/services/auth_service.dart';
import 'package:task_management_app/core/constants/app_colors.dart';
import 'package:task_management_app/presentation/widgets/buttons/custom_button.dart';
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
        backgroundColor: successColor,
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
        backgroundColor: errorColor,
      );
    } catch (e) {
      if (!mounted) return;
      showFloatingSnackBar(
        context,
        message: "An unexpected error occurred.",
        backgroundColor: errorColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentTheme = themeProvider.themeMode.name;
    return Padding(
      padding: const EdgeInsets.only(left: 90),
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
                          onPressed: () => logout(),
                        ),
                      );
                    }),
                Menu(
                    text: 'Theme',
                    icon: Icons.light_mode,
                    press: () async {
                      final selected =
                          await showThemeChoiceDialog(context, currentTheme);

                      if (selected != null) {
                        if (selected == 'system') {
                          themeProvider.setThemeMode(ThemeMode.system);
                        } else if (selected == 'light') {
                          themeProvider.setThemeMode(ThemeMode.light);
                        } else {
                          themeProvider.setThemeMode(ThemeMode.dark);
                        }
                      }
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> showThemeChoiceDialog(BuildContext context, String current) {
    String temp = current;

    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      animationStyle: AnimationStyle(
        curve: Curves.easeInQuart,
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 200),
      ),
      builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(
            radioTheme: RadioThemeData(
              fillColor: WidgetStatePropertyAll(blackColor),
            ),
          ),
          child: AlertDialog(
            elevation: 10,
            title: Text(
              'Choose theme',
              style: GoogleFonts.poppins(
                color: blackColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: StatefulBuilder(
              builder: (context, setState) {
                return RadioGroup<String>(
                  groupValue: temp,
                  onChanged: (v) => setState(() => temp = v!),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioMenuButton<String>(
                        value: 'system',
                        groupValue: temp,
                        onChanged: (v) => setState(() => temp = v!),
                        child: Text(
                          'System (Default)',
                          style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      RadioMenuButton<String>(
                        value: 'light',
                        groupValue: temp,
                        onChanged: (v) => setState(() => temp = v!),
                        child: Text(
                          'Light Mode',
                          style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      RadioMenuButton<String>(
                        value: 'dark',
                        groupValue: temp,
                        onChanged: (v) => setState(() => temp = v!),
                        child: Text(
                          'Dark Mode',
                          style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.raleway(
                    color: blackColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CustomButton(
                onPressed: () => Navigator.of(context).pop(temp),
                buttonColor: primaryButtonColor,
                buttonText: "Ok",
                buttonTextColor: whiteColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
