import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        .get();

    tasks = snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'title': doc['title'],
        'isCompleted': doc['isCompleted'],
      };
    }).toList();
    _isLoading = false;
    notifyListeners();
  }

//Add Task
  Future<void> addTask(String taskTitle) async {
    final taskRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .add({
      'title': taskTitle,
      'isCompleted': false,
    });

    tasks.add({
      'id': taskRef.id,
      'title': taskTitle,
      'isCompleted': false,
    });
    notifyListeners();
  }

//Delete Task
  Future<void> deleteTask(String taskId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .delete();

    tasks.removeWhere((task) => task['id'] == taskId);
    notifyListeners();
  }

//Delete All Tasks
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

//Edit Task
  Future<void> editTask(String taskId, String newTitle) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .update({'title': newTitle});

    final index = tasks.indexWhere((task) => task['id'] == taskId);
    if (index != -1) {
      tasks[index]['title'] = newTitle;
    }
    notifyListeners();
  }

//Toggle Status
  Future<void> toggleTaskStatus(String taskId, bool isCompleted) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .update({'isCompleted': isCompleted});

    final index = tasks.indexWhere((task) => task['id'] == taskId);
    if (index != -1) {
      tasks[index]['isCompleted'] = isCompleted;
    }
    notifyListeners();
  }

//Update Search
  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }
}
