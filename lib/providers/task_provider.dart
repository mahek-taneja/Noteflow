import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../utils/file_utils.dart'; // Ensure this import exists

/// Task Model
class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime dueDate;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.dueDate,
  });

  /// CopyWith method for immutability
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  /// Convert Task to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate.toIso8601String(),
    };
  }

  /// Create Task from Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? const Uuid().v4(), // Use existing ID if available
      title: map['title'] ?? 'Untitled Task',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      dueDate: DateTime.tryParse(map['dueDate'] ?? '') ?? DateTime.now(),
    );
  }
}

/// Task Provider
class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  final Uuid _uuid = const Uuid();

  /// Get all tasks
  List<Task> get tasks => List.unmodifiable(_tasks);

  /// Add a new task
  void addTask(String title,
      {String description = '', required DateTime dueDate}) {
    _tasks.add(Task(
      id: _uuid.v4(),
      title: title,
      description: description,
      dueDate: dueDate,
    ));
    notifyListeners();
  }

  /// Get tasks for a specific date
  List<Task> getTasksForDate(DateTime date) {
    return _tasks.where((task) {
      return task.dueDate.year == date.year &&
          task.dueDate.month == date.month &&
          task.dueDate.day == date.day;
    }).toList();
  }

  /// Toggle task completion
  void toggleTaskStatus(String taskId) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      _tasks[index] =
          _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted);
      notifyListeners();
    }
  }

  /// Remove a task by ID
  void removeTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  /// Clear all tasks
  void clearTasks() {
    _tasks.clear();
    notifyListeners();
  }

  /// Export tasks to JSON (returns "[]" if no tasks)
  String exportTasksToJson() {
    final tasksMap = _tasks.map((task) => task.toMap()).toList();
    return jsonEncode(tasksMap);
  }

  /// Import tasks from JSON, avoiding duplicates
  void importTasksFromJson(String jsonString) {
    try {
      final List<dynamic> tasksList = jsonDecode(jsonString);
      Set<String> existingIds = _tasks.map((task) => task.id).toSet();

      for (var taskMap in tasksList) {
        Task newTask = Task.fromMap(taskMap);
        if (!existingIds.contains(newTask.id)) {
          _tasks.add(newTask);
          existingIds.add(newTask.id); // Keep track of added task IDs
        }
      }
      notifyListeners();
    } catch (e) {
      print("Error importing tasks: $e");
      // Optionally show a UI message here for the error
    }
  }

  /// Save tasks to a file (called from CollaborateScreen)
  Future<String?> saveTasksToFile() async {
    try {
      String jsonTasks = exportTasksToJson();
      // Call writeFile instead of writeToFile
      return await FileUtils.writeFile("tasks.json", jsonTasks);
    } catch (e) {
      print("Error saving tasks to file: $e");
      return null;
    }
  }
}



