import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/logic/services/auth_service.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = authservice.value.currentUser!.uid;
    String formattedDate = DateFormat('yMMMMd').format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserName(uid: uid),
        const SizedBox(height: 5),
        Text(
          formattedDate,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

class UserName extends StatelessWidget {
  final String uid;
  const UserName({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            "Loading...",
            style: theme.textTheme.titleMedium,
          );
        }
        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return Text(
            "Welcome User",
            style: theme.textTheme.titleLarge,
          );
        }
        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final name = userData["name"] ?? "User";
        return Text(
          "Welcome $name",
          style: theme.textTheme.titleLarge,
        );
      },
    );
  }
}
