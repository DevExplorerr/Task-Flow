import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_management_app/logic/services/notification_service.dart';

class TaskProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _tasks = [];
  String _searchQuery = '';
  bool _isLoading = true;
  StreamSubscription? _taskSubscription;
  bool _cacheLoaded = false;

  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> get tasks {
    if (_searchQuery.isEmpty) return _tasks;
    return _tasks
        .where((task) =>
            task['title'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<Map<String, dynamic>> _mapDocs(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'title': doc['title'],
        'isCompleted': doc['isCompleted'],
        'reminder': doc['reminder'],
      };
    }).toList();
  }

  // Load Tasks (Firestore local caching)
  void listenToTasks() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _isLoading = true;
    notifyListeners();

    _taskSubscription?.cancel();

    // Load task from cache first
    final taskCollection = _firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .orderBy('createdAt', descending: true);

    if (!_cacheLoaded) {
      _cacheLoaded = true;
      taskCollection
          .get(const GetOptions(source: Source.cache))
          .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          _tasks = _mapDocs(snapshot);
          _isLoading = false;
          notifyListeners();
        }
      });
    }

    // Listen to Firestore updates in real time
    _taskSubscription = taskCollection.snapshots().listen((snapshot) {
      _tasks = _mapDocs(snapshot);
      _isLoading = false;
      notifyListeners();
    });
  }

  // Dispose listener
  @override
  void dispose() {
    _taskSubscription?.cancel();
    super.dispose();
  }

  // Manual refresh
  Future<void> refreshTasks() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _isLoading = true;

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .get(const GetOptions(source: Source.server));

    _tasks = _mapDocs(snapshot);
    _isLoading = false;
    notifyListeners();
  }

  // Add Task
  Future<void> addTask(String title, {DateTime? reminder}) async {
    final uid = _auth.currentUser!.uid;
    final colRef = _firestore.collection('users').doc(uid).collection('tasks');

    final docRef = await colRef.add({
      'title': title,
      'isCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
      'reminder': reminder != null ? Timestamp.fromDate(reminder) : null,
    });

    if (reminder != null) {
      await NotificationService.scheduleNotification(
        taskId: docRef.id,
        title: "Task Reminder",
        body: title,
        scheduledTime: reminder,
      );
    }
  }

  // Edit Task
  Future<void> editTask(String taskId, String newTitle,
      {DateTime? newReminder}) async {
    final uid = _auth.currentUser!.uid;
    final docRef =
        _firestore.collection('users').doc(uid).collection('tasks').doc(taskId);

    await docRef.update({
      'title': newTitle,
      'reminder': newReminder != null ? Timestamp.fromDate(newReminder) : null,
    });

    await NotificationService.cancelNotification(taskId);

    final existingTask =
        _tasks.firstWhere((task) => task['id'] == taskId, orElse: () => {});
    final isCompleted = existingTask['isCompleted'] ?? false;

    if (!isCompleted && newReminder != null) {
      await NotificationService.scheduleNotification(
        taskId: taskId,
        title: "Task Reminder",
        body: newTitle,
        scheduledTime: newReminder,
      );
    }
  }

  // Delete Task
  Future<void> deleteTask(String taskId) async {
    final uid = _auth.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .delete();

    await NotificationService.cancelNotification(taskId);
  }

  // Delete All
  Future<void> deleteAllTasks() async {
    final uid = _auth.currentUser!.uid;
    final batch = _firestore.batch();

    final cancelFutures = <Future>[];

    for (final task in _tasks) {
      final docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(task['id']);
      batch.delete(docRef);
      cancelFutures.add(NotificationService.cancelNotification(task['id']));
    }

    await batch.commit();
    await Future.wait(cancelFutures);
  }

  // Toggle Completion Status
  Future<void> toggleTaskStatus(String taskId, bool isCompleted) async {
    final uid = _auth.currentUser!.uid;
    final docRef =
        _firestore.collection('users').doc(uid).collection('tasks').doc(taskId);

    await docRef.update({'isCompleted': isCompleted});

    final task =
        _tasks.firstWhere((task) => task['id'] == taskId, orElse: () => {});
    final reminderTimestamp = task['reminder'];
    final reminder = reminderTimestamp != null
        ? (reminderTimestamp as Timestamp).toDate()
        : null;

    if (isCompleted) {
      await NotificationService.cancelNotification(taskId);
    } else if (reminder != null && reminder.isAfter(DateTime.now())) {
      await NotificationService.scheduleNotification(
        taskId: taskId,
        title: "Task Reminder",
        body: task['title'],
        scheduledTime: reminder,
      );
    }
  }

  // Search
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
