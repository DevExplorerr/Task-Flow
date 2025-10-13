// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/firebase/firebase_options.dart';
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
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(375, 812),
      child: MaterialApp(
        title: "Task Management",
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).themeData,
        // theme: ThemeData(
        //     textSelectionTheme: TextSelectionThemeData(
        //         cursorColor: blackColor,
        //         selectionColor: greyColor.withOpacity(0.5),
        //         selectionHandleColor: blackColor),
        //     textButtonTheme: TextButtonThemeData(
        //         style: ButtonStyle(
        //             overlayColor: MaterialStateProperty.all(
        //                 blackColor.withOpacity(0.1)))),
        //     iconButtonTheme: IconButtonThemeData(
        //       style: ButtonStyle(
        //         overlayColor:
        //             MaterialStateProperty.all(blackColor.withOpacity(0.1)),
        //       ),
        //     ),
        //     elevatedButtonTheme: ElevatedButtonThemeData(
        //       style: ButtonStyle(
        //         overlayColor:
        //             MaterialStateProperty.all(whiteColor.withOpacity(0.1)),
        //       ),
        //     )),
        home: StreamBuilder<User?>(
          stream: authservice.value.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: blackColor),
              );
            } else if (snapshot.hasData) {
              return const HomeScreen();
            } else {
              return const SplashScreen();
            }
          },
        ),
      ),
    );
  }
}
