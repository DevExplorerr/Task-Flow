// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/provider/task_provider.dart';
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

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
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
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: whiteColor,
            actions: [
              Padding(
                padding: EdgeInsets.only(top: 10.h, right: 15.w),
                child: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: blackColor),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ),
            ],
            flexibleSpace: Padding(
              padding: EdgeInsets.only(
                top: 50.h,
                left: 20.w,
                right: 20.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeAppBar(),
                  SizedBox(height: 25.h),
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
                  taskProvider.addTask(taskTitle);
                  titleController.clear();
                  Navigator.of(context).pop();
                },
              ),
            );
          },
          child: Container(
            height: 60.h,
            width: 60.w,
            decoration: BoxDecoration(
              color: whiteColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: greyColor,
                  offset: const Offset(1, 1),
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
            SizedBox(height: 5.h),
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
                      SizedBox(height: 15.h),
                      Text(
                        "No tasks yet",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: greyColor,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Tap + to add your first task",
                        style: TextStyle(
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
                        EdgeInsets.only(left: 20.w, right: 20.w, bottom: 90.h),
                    itemCount: taskProvider.task.length,
                    itemBuilder: (context, index) {
                      final tasks = taskProvider.task[index];
                      return TaskListTile(
                        taskTitle: tasks['title'],
                        isCompleted: tasks['isCompleted'],
                        onStatusToggle: (value) {
                          taskProvider.toggleTaskStatus(tasks['id'], value);
                        },
                        onDelete: () {
                          taskProvider.deleteTask(tasks['id']);
                        },
                        onEdit: (updatedTitle) {
                          taskProvider.editTask(tasks['id'], updatedTitle);
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
