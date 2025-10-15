import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/core/constants/app_colors.dart';
import 'package:task_management_app/logic/provider/theme_provider.dart';
import 'package:task_management_app/presentation/widgets/app_bar/custom_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: const CustomAppBar(
          title: "General",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25.0,
          vertical: kToolbarHeight,
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                context.read<ThemeProvider>().toggleTheme();
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.light_mode,
                    color: blackColor,
                  ),
                  const SizedBox(width: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Color Scheme",
                        style: GoogleFonts.poppins(
                          color: blackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "System (Default)",
                        style: GoogleFonts.poppins(
                          color: blackColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 35),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  const Icon(
                    Icons.brush,
                    color: blackColor,
                  ),
                  const SizedBox(width: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Accent Color",
                        style: GoogleFonts.poppins(
                          color: blackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Default",
                        style: GoogleFonts.poppins(
                          color: blackColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 35),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  const Icon(
                    Icons.language,
                    color: blackColor,
                  ),
                  const SizedBox(width: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Language",
                        style: GoogleFonts.poppins(
                          color: blackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "English",
                        style: GoogleFonts.poppins(
                          color: blackColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<String?> showThemeChoiceDialog(BuildContext context, String current) {
  //   String temp = current;

  //   return showDialog<String>(
  //     context: context,
  //     barrierDismissible: true,
  //     animationStyle: AnimationStyle(
  //       curve: Curves.easeInQuart,
  //       duration: const Duration(milliseconds: 300),
  //       reverseDuration: const Duration(milliseconds: 200),
  //     ),
  //     builder: (context) {
  //       return Theme(
  //         data: Theme.of(context).copyWith(
  //           radioTheme: RadioThemeData(
  //             fillColor: WidgetStatePropertyAll(blackColor),
  //           ),
  //         ),
  //         child: AlertDialog(
  //           elevation: 10,
  //           title: Text(
  //             'Choose theme',
  //             style: GoogleFonts.poppins(
  //               color: blackColor,
  //               fontSize: 20.sp,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //           content: StatefulBuilder(
  //             builder: (context, setState) {
  //               return RadioGroup<String>(
  //                 groupValue: temp,
  //                 onChanged: (v) => setState(() => temp = v!),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     RadioMenuButton<String>(
  //                       value: 'system',
  //                       groupValue: temp,
  //                       onChanged: (v) => setState(() => temp = v!),
  //                       child: Text(
  //                         'System (Default)',
  //                         style: GoogleFonts.poppins(
  //                           color: textColor,
  //                           fontSize: 16.sp,
  //                           fontWeight: FontWeight.w400,
  //                         ),
  //                       ),
  //                     ),
  //                     RadioMenuButton<String>(
  //                       value: 'light',
  //                       groupValue: temp,
  //                       onChanged: (v) => setState(() => temp = v!),
  //                       child: Text(
  //                         'Light Mode',
  //                         style: GoogleFonts.poppins(
  //                           color: textColor,
  //                           fontSize: 16.sp,
  //                           fontWeight: FontWeight.w400,
  //                         ),
  //                       ),
  //                     ),
  //                     RadioMenuButton<String>(
  //                       value: 'dark',
  //                       groupValue: temp,
  //                       onChanged: (v) => setState(() => temp = v!),
  //                       child: Text(
  //                         'Dark Mode',
  //                         style: GoogleFonts.poppins(
  //                           color: textColor,
  //                           fontSize: 16.sp,
  //                           fontWeight: FontWeight.w400,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.of(context).pop(null),
  //               child: Text(
  //                 'Cancel',
  //                 style: GoogleFonts.raleway(
  //                   color: blackColor,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //             ),
  //             CustomButton(
  //               onPressed: () => Navigator.of(context).pop(temp),
  //               buttonColor: primaryButtonColor,
  //               buttonText: "Ok",
  //               buttonTextColor: whiteColor,
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
