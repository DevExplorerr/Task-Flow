// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/global/snackbar.dart';
import 'package:task_management_app/logic/provider/task_provider.dart';
import 'package:task_management_app/logic/services/notification_service.dart';
import 'package:task_management_app/core/constants/app_colors.dart';
import 'package:task_management_app/presentation/widgets/buttons/custom_bottom_sheet.dart';
import 'package:task_management_app/presentation/widgets/app_bar/home_app_bar.dart';
import 'package:task_management_app/presentation/widgets/drawer/home_drawer.dart';
import 'package:task_management_app/presentation/widgets/tasks/task_search_bar.dart';
import '../../widgets/tasks/task_list_tile.dart';
import '../../widgets/tasks/task_sub_header.dart';

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
        showFloatingSnackBar(
          context,
          message: "Enable notification to receive task reminders.",
          backgroundColor: AppColors.primary,
          action: SnackBarAction(
            label: "Open Settings",
            textColor: AppColors.white,
            onPressed: () async => await openAppSettings(),
          ),
          duration: const Duration(seconds: 4),
        );
      }

      context.read<TaskProvider>().listenToTasks();
    });
  }

  void _openAddTaskBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      backgroundColor: theme.bottomSheetTheme.backgroundColor,
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
    final theme = Theme.of(context);
    final brightnessCheck = theme.brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(165.h),
            child: const _StaticAppBar()),
        endDrawer: const HomeDrawer(),
        endDrawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: 100,
        drawerScrimColor: AppColors.black.withOpacity(0.3),
        floatingActionButton: const _AddTaskFloatingButton(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Selector<TaskProvider, int>(
              selector: (_, p) => p.tasks.length,
              builder: (_, taskcount, __) => TaskSubHeader(
                ondeleteAll: context.read<TaskProvider>().deleteAllTasks,
                taskCount: taskcount,
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Selector<TaskProvider, bool>(
                selector: (_, p) => p.isLoading,
                builder: (_, isLoading, __) {
                  if (isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color:
                            brightnessCheck ? AppColors.white : AppColors.black,
                      ),
                    );
                  }

                  return Selector<TaskProvider, List<Map<String, dynamic>>>(
                    selector: (_, p) => p.tasks,
                    builder: (_, taskList, __) {
                      if (taskList.isEmpty) return const _EmptyState();

                      return RefreshIndicator(
                        color: brightnessCheck
                            ? AppColors.secondary
                            : AppColors.primary,
                        backgroundColor: brightnessCheck
                            ? AppColors.primary
                            : AppColors.secondary,
                        onRefresh: context.read<TaskProvider>().refreshTasks,
                        child: ListView.builder(
                          key: const PageStorageKey('taskList'),
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 120,
                          ),
                          itemCount: taskList.length,
                          itemBuilder: (context, index) {
                            final tasks = taskList[index];
                            return RepaintBoundary(
                              child: TaskListTile(
                                key: ValueKey(tasks['id']),
                                taskTitle: tasks['title'],
                                isCompleted: tasks['isCompleted'],
                                reminderDateTime: tasks['reminder'] != null
                                    ? (tasks['reminder'] as Timestamp).toDate()
                                    : null,
                                onStatusToggle: (value) {
                                  HapticFeedback.selectionClick();
                                  context
                                      .read<TaskProvider>()
                                      .toggleTaskStatus(tasks['id'], value);
                                },
                                onDelete: () {
                                  HapticFeedback.heavyImpact();
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
                        ),
                      );
                    },
                  );
                },
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
    final theme = Theme.of(context);
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 15),
          child: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: theme.iconTheme.color),
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
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        context
            .findAncestorStateOfType<_HomeScreenState>()
            ?._openAddTaskBottomSheet(context);
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: theme.floatingActionButtonTheme.backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.8),
              offset: Offset(0, 0),
              spreadRadius: 2,
              blurRadius: 10,
            )
          ],
        ),
        child: Icon(Icons.add, color: theme.iconTheme.color, size: 30),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox, size: 80, color: AppColors.grey),
            const SizedBox(height: 15),
            Text(
              "No tasks yet",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Tap + to add your first task",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
