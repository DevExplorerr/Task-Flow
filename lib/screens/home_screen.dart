// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/provider/task_provider.dart';
import 'package:task_management_app/widgets/colors.dart';
import 'package:task_management_app/widgets/home_app_bar.dart';
import 'package:task_management_app/widgets/home_drawer.dart';
import 'package:task_management_app/widgets/task_search_bar.dart';
import '../widgets/task_list_tile.dart.dart';
import '../widgets/task_sub_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: bgColor,
          automaticallyImplyLeading: false,
          toolbarHeight: 100.h,
          title: HomeAppBar(),
        ),
        endDrawer: HomeDrawer(),
        endDrawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: 100,
        drawerScrimColor: blackColor.withOpacity(0.3),
        backgroundColor: bgColor,
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TaskSearchBar(
                onAddTask: taskProvider.addTask,
                onSearchChanged: taskProvider.updateSearchQuery,
              ),
              SizedBox(height: 30.h),
              TaskSubHeader(
                ondeleteAll: taskProvider.deleteAllTasks,
                taskCount: taskProvider.task.length,
              ),
              SizedBox(height: 40.h),
              if (taskProvider.isLoading)
                const Center(
                    child: CircularProgressIndicator(color: blackColor))
              else
                ...taskProvider.task.map((task) => TaskListTile(
                      taskTitle: task['title'],
                      isCompleted: task['isCompleted'],
                      onStatusToggle: (value) {
                        taskProvider.toggleTaskStatus(task['id'], value);
                      },
                      onDelete: () {
                        taskProvider.deleteTask(task['id']);
                      },
                      onEdit: (updatedTitle) {
                        taskProvider.editTask(task['id'], updatedTitle);
                      },
                    ))
            ])
          ],
        ),
      ),
    );
  }
}
