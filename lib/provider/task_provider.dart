import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_management_app/services/notification_service.dart';

class TaskProvider extends ChangeNotifier {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  List<Map<String, dynamic>> tasks = [];
  String _searchQuery = '';
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> get task {
    if (_searchQuery.isEmpty) return tasks;
    return tasks
        .where((task) =>
            task['title'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

//Load Tasks
  Future<void> loadTasksFromFirestore() async {
    _isLoading = true;
    notifyListeners();
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .get();

    tasks = snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'title': doc['title'],
        'isCompleted': doc['isCompleted'],
        'reminder': doc['reminder'],
      };
    }).toList();
    _isLoading = false;
    notifyListeners();
  }

//Add Task
  Future<void> addTask(String taskTitle, {DateTime? reminder}) async {
    final col = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks');

    final docRef = await col.add({
      'title': taskTitle,
      'isCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
      'reminder': reminder != null ? Timestamp.fromDate(reminder) : null,
    });

    tasks.insert(0, {
      'id': docRef.id,
      'title': taskTitle,
      'isCompleted': false,
      'reminder': reminder != null ? Timestamp.fromDate(reminder) : null,
    });

    if (reminder != null) {
      await NotificationService.scheduleNotification(
          taskId: docRef.id,
          title: "Task Reminder",
          body: taskTitle,
          scheduledTime: reminder);
    }

    notifyListeners();
  }

  //  Edit Task
  Future<void> editTask(String taskId, String newTitle,
      {DateTime? newReminder}) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId);

    await docRef.update({
      'title': newTitle,
      'reminder': newReminder != null ? Timestamp.fromDate(newReminder) : null,
    });

    final index = tasks.indexWhere((task) => task['id'] == taskId);
    if (index != -1) {
      tasks[index]['title'] = newTitle;
      tasks[index]['reminder'] =
          newReminder != null ? Timestamp.fromDate(newReminder) : null;
    }

    // Cancel previous and reschedule notification
    await NotificationService.cancelNotification(taskId);
    if (newReminder != null) {
      await NotificationService.scheduleNotification(
          taskId: taskId,
          title: 'Task Reminder',
          body: newTitle,
          scheduledTime: newReminder);
    }
    notifyListeners();
  }

// Delete Task
  Future<void> deleteTask(String taskId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .delete();

    tasks.removeWhere((task) => task['id'] == taskId);

    // Cancel reminder notification if task is deleted
    await NotificationService.cancelNotification(taskId);
    notifyListeners();
  }

// Delete All Tasks
  Future<void> deleteAllTasks() async {
    final batch = FirebaseFirestore.instance.batch();
    for (var task in tasks) {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(task['id']);
      batch.delete(docRef);
    }

    await batch.commit();

    tasks.clear();
    notifyListeners();
  }

// Toggle Status
  Future<void> toggleTaskStatus(String taskId, bool isCompleted) async {
    final taskRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId);

    // Update Firestore
    await taskRef.update({'isCompleted': isCompleted});

    // Update List
    final index = tasks.indexWhere((task) => task['id'] == taskId);
    if (index != -1) {
      tasks[index]['isCompleted'] = isCompleted;

      // Handling notifications
      final reminderTimestamp = tasks[index]['reminder'];
      final reminder = reminderTimestamp != null
          ? (reminderTimestamp as Timestamp).toDate()
          : null;

      if (isCompleted) {
        // Cancel notification when task completed
        await NotificationService.cancelNotification(taskId);
      } else {
        // Reschedule if uncompleted again & reminder still valid
        if (reminder != null && reminder.isAfter(DateTime.now())) {
          await NotificationService.scheduleNotification(
            taskId: taskId,
            title: "Task Reminder",
            body: tasks[index]['title'],
            scheduledTime: reminder,
          );
        }
      }
    }
    notifyListeners();
  }

  // Update Search
  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

//   Future<void> toggleTaskStatus(String taskId, bool isCompleted) async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .collection('tasks')
//         .doc(taskId)
//         .update({'isCompleted': isCompleted});

//     final index = tasks.indexWhere((task) => task['id'] == taskId);
//     if (index != -1) {
//       tasks[index]['isCompleted'] = isCompleted;
//     }
//     notifyListeners();
//   }
}


  // Future<void> addTask(String taskTitle, {DateTime? reminder}) async {
  //   final taskRef = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uid)
  //       .collection('tasks')
  //       .add({
  //     'title': taskTitle,
  //     'isCompleted': false,
  //     'createdAt': FieldValue.serverTimestamp(),
  //     'reminder': reminder != null ? Timestamp.fromDate(reminder) : null,
  //   });

  //   tasks.add({
  //     'id': taskRef.id,
  //     'title': taskTitle,
  //     'isCompleted': false,
  //     'reminder': reminder != null ? Timestamp.fromDate(reminder) : null,
  //   });

  //   //schedule notification if reminder is set
  //   if (reminder != null) {
  //     await NotificationService.scheduleNotification(
  //         taskId: taskRef.id,
  //         title: "Task Reminder",
  //         body: taskTitle,
  //         scheduledTime: reminder);
  //   }
  //   notifyListeners();
  // }

    // Future<void> editTask(String taskId, String newTitle,
  //     {DateTime? newReminder}) async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uid)
  //       .collection('tasks')
  //       .doc(taskId)
  //       .update({
  //     'title': newTitle,
  //     'reminder': newReminder != null ? Timestamp.fromDate(newReminder) : null,
  //   });

  //   final index = tasks.indexWhere((task) => task['id'] == taskId);
  //   if (index != -1) {
  //     tasks[index]['title'] = newTitle;
  //     tasks[index]['reminder'] =
  //         newReminder != null ? Timestamp.fromDate(newReminder) : null;
  //   }


  //   await NotificationService.cancelNotification(taskId);
  //   if (newReminder != null) {
  //     await NotificationService.scheduleNotification(
  //         taskId: taskId,
  //         title: "Task Reminder",
  //         body: newTitle,
  //         scheduledTime: newReminder);
  //   }
  //   notifyListeners();
  // }