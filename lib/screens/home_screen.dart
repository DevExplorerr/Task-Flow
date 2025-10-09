// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/global/snackbar.dart';
import 'package:task_management_app/provider/task_provider.dart';
import 'package:task_management_app/services/notification_service.dart';
import 'package:task_management_app/widgets/colors.dart';
import 'package:task_management_app/widgets/custom_bottom_sheet.dart';
import 'package:task_management_app/widgets/home_app_bar.dart';
import 'package:task_management_app/widgets/home_drawer.dart';
import 'package:task_management_app/widgets/task_search_bar.dart';
import '../widgets/task_list_tile.dart';
import '../widgets/task_sub_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController titleController = TextEditingController();
  DateTime? reminderDateTime;

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool granted =
          await NotificationService.checkAndRequestPermission(context);

      if (!granted) {
        showFloatingSnackBar(context,
            message: "Enable notification to receive task reminders.",
            backgroundColor: blackColor,
            action: SnackBarAction(
                label: "Open Settings",
                textColor: whiteColor,
                onPressed: () async {
                  await openAppSettings();
                }),
            duration: const Duration(seconds: 4));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(165.h),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: whiteColor,
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 15),
                child: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: blackColor),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ),
            ],
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeAppBar(),
                  const SizedBox(height: 25),
                  TaskSearchBar(
                      onSearchChanged: taskProvider.updateSearchQuery),
                ],
              ),
            ),
          ),
        ),
        endDrawer: const HomeDrawer(),
        endDrawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: 100,
        drawerScrimColor: blackColor.withOpacity(0.3),
        floatingActionButton: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              elevation: 10,
              backgroundColor: bgColor,
              showDragHandle: true,
              isScrollControlled: true,
              context: context,
              builder: (context) => CustomBottomSheet(
                hintText: "Add task here...",
                text: "New Task",
                buttonText: "Add",
                controller: titleController,
                onPressed: () {
                  final taskTitle = titleController.text;
                  if (taskTitle.trim().isEmpty) return;
                  taskProvider.addTask(taskTitle, reminder: reminderDateTime);
                  titleController.clear();
                  Navigator.of(context).pop();
                },
                onReminderSelected: (dateTime) {
                  setState(() {
                    reminderDateTime = dateTime;
                  });
                },
              ),
            );
          },
          child: Container(
            height: 60.h,
            width: 60.w,
            decoration: const BoxDecoration(
              color: whiteColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: greyColor,
                  offset: Offset(1, 1),
                  blurRadius: 10,
                )
              ],
            ),
            child: const Icon(Icons.add, color: blackColor, size: 30),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskSubHeader(
              ondeleteAll: taskProvider.deleteAllTasks,
              taskCount: taskProvider.task.length,
            ),
            const SizedBox(height: 5),
            if (taskProvider.isLoading)
              const Expanded(
                  child: Center(
                      child: CircularProgressIndicator(color: blackColor)))
            else if (taskProvider.task.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inbox, size: 80, color: greyColor),
                      const SizedBox(height: 15),
                      Text(
                        "No tasks yet",
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: greyColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Tap + to add your first task",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 96),
                    itemCount: taskProvider.task.length,
                    itemBuilder: (context, index) {
                      final tasks = taskProvider.task[index];
                      return TaskListTile(
                        taskTitle: tasks['title'],
                        isCompleted: tasks['isCompleted'],
                        reminderDateTime: tasks['reminder'] != null
                            ? (tasks['reminder'] as Timestamp).toDate()
                            : null,
                        onStatusToggle: (value) {
                          taskProvider.toggleTaskStatus(tasks['id'], value);
                        },
                        onDelete: () {
                          taskProvider.deleteTask(tasks['id']);
                        },
                        onEdit: (updatedTitle, updateReminder) {
                          taskProvider.editTask(tasks['id'], updatedTitle,
                              newReminder: updateReminder);
                        },
                      );
                    }),
              )
          ],
        ),
      ),
    );
  }
}
