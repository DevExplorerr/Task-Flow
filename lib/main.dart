// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management_app/firebase/firebase_options.dart';
import 'package:task_management_app/logic/provider/settings_provider.dart';
import 'package:task_management_app/logic/provider/theme_provider.dart';
import 'package:task_management_app/logic/services/auth_service.dart';
import 'package:task_management_app/logic/provider/task_provider.dart';
import 'package:task_management_app/presentation/screens/home/home_screen.dart';
import 'package:task_management_app/presentation/screens/splash/splash_screen.dart';
import 'package:task_management_app/logic/services/notification_service.dart';
import 'package:task_management_app/core/constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.init();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(prefs: prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(prefs: prefs),
        ),
      ],
      child: const TaskFlow(),
    ),
  );
}

class TaskFlow extends StatelessWidget {
  const TaskFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: "Task Management",
          debugShowCheckedModeBanner: false,
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.themeMode,
          home: StreamBuilder<User?>(
            stream: authservice.value.authStateChanges,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.black),
                );
              } else if (snapshot.hasData) {
                return const HomeScreen();
              } else {
                return const SplashScreen();
              }
            },
          ),
        );
      },
    );
  }
}
