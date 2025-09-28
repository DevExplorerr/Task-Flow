import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/service/auth_service.dart';
import 'package:task_management_app/widgets/colors.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = authservice.value.currentUser!.uid;
    String formattedDate = DateFormat('yMMMMd').format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _UserName(uid: uid),
        const SizedBox(height: 5),
        Text(
          formattedDate,
          style: GoogleFonts.poppins(
            color: textColor,
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}

class _UserName extends StatelessWidget {
  final String uid;
  const _UserName({required this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text("Loading...");
        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final name = userData["name"] ?? "User";
        return Text(
          "Welcome $name",
          style: GoogleFonts.poppins(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
          ),
        );
      },
    );
  }
}
