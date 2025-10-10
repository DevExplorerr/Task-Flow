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
              onPressed: () async => await openAppSettings(),
            ),
            duration: const Duration(seconds: 4));
      }

      context.read<TaskProvider>().listenToTasks();
    });
  }

  void _openAddTaskBottomSheet(BuildContext context) {
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
          final taskTitle = titleController.text.trim();
          if (taskTitle.isEmpty) return;
          context
              .read<TaskProvider>()
              .addTask(taskTitle, reminder: reminderDateTime);

          titleController.clear();
          Navigator.of(context).pop();
        },
        onReminderSelected: (dateTime) => reminderDateTime = dateTime,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(165.h),
            child: const _StaticAppBar()),
        endDrawer: const HomeDrawer(),
        endDrawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: 100,
        drawerScrimColor: blackColor.withOpacity(0.3),
        floatingActionButton: const _AddTaskFloatingButton(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskSubHeader(
              ondeleteAll: taskProvider.deleteAllTasks,
              taskCount: taskProvider.tasks.length,
            ),
            const SizedBox(height: 5),
            if (taskProvider.isLoading)
              const Expanded(
                  child: Center(
                      child: CircularProgressIndicator(color: blackColor)))
            else if (taskProvider.tasks.isEmpty)
              const Expanded(child: _EmptyState())
            else
              Expanded(
                child: RefreshIndicator(
                  color: blackColor,
                  backgroundColor: whiteColor,
                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                  onRefresh: context.read<TaskProvider>().refreshTasks,
                  child: Selector<TaskProvider, List<Map<String, dynamic>>>(
                    selector: (_, provider) => provider.tasks,
                    builder: (context, taskList, _) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 96),
                        itemCount: taskList.length,
                        itemBuilder: (context, index) {
                          final tasks = taskList[index];
                          return RepaintBoundary(
                            child: TaskListTile(
                              taskTitle: tasks['title'],
                              isCompleted: tasks['isCompleted'],
                              reminderDateTime: tasks['reminder'] != null
                                  ? (tasks['reminder'] as Timestamp).toDate()
                                  : null,
                              onStatusToggle: (value) {
                                context
                                    .read<TaskProvider>()
                                    .toggleTaskStatus(tasks['id'], value);
                              },
                              onDelete: () {
                                context
                                    .read<TaskProvider>()
                                    .deleteTask(tasks['id']);
                              },
                              onEdit: (updatedTitle, updateReminder) {
                                context.read<TaskProvider>().editTask(
                                      tasks['id'],
                                      updatedTitle,
                                      newReminder: updateReminder,
                                    );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StaticAppBar extends StatelessWidget {
  const _StaticAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
            Consumer<TaskProvider>(
              builder: (_, provider, __) =>
                  TaskSearchBar(onSearchChanged: provider.updateSearchQuery),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddTaskFloatingButton extends StatelessWidget {
  const _AddTaskFloatingButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context
          .findAncestorStateOfType<_HomeScreenState>()
          ?._openAddTaskBottomSheet(context),
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
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
