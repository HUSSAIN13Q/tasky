import 'package:flutter/material.dart';
import 'package:tasky/model/task.dart';
import 'package:tasky/services/client_services.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  Map<int, List<Task>> _tasksByUser = {};

  List<Task> get tasks => _tasks.reversed.toList();
  List<Task> tasksByUser(int userId) => _tasksByUser[userId] ?? [];

  Future<void> fetchAllTasks() async {
    try {
      final response = await Client.dio.get('/tasks');
      if (response.data != null && response.data['data'] != null) {
        final tasksData = response.data['data']['tasks'] as List;

        _tasks = tasksData.map<Task>((taskData) {
          final task = Task.fromJson(taskData);
          print(
              "Fetched task: ${task.title}, Status: ${task.status}, Comments: ${task.comments}");
          return task;
        }).toList();

        notifyListeners();
      } else {
        print("No task data found in response.");
      }
    } catch (e) {
      print("Error fetching all tasks: $e");
    }
  }

  Future<void> fetchTasks() async {
    try {
      final response = await Client.dio.get('/tasks');
      if (response.data != null && response.data['data'] != null) {
        final tasksData = response.data['data']['tasks'] as List;
        _tasks = tasksData.map((taskData) => Task.fromJson(taskData)).toList();
        notifyListeners();
      } else {
        print("No task data found for authenticated user.");
      }
    } catch (e) {
      print("Error fetching tasks for authenticated user: $e");
    }
  }

  Future<void> fetchTasksByUserId(int userId) async {
    try {
      print("Fetching tasks for user ID: $userId");
      final response =
          await Client.dio.get('/tasks', queryParameters: {'user_id': userId});
      if (response.data != null && response.data['data'] != null) {
        final tasksData = response.data['data']['tasks'] as List;
        _tasksByUser[userId] =
            tasksData.map((taskData) => Task.fromJson(taskData)).toList();
        notifyListeners();
      } else {
        print("No tasks data found for user $userId.");
        _tasksByUser[userId] = [];
      }
    } catch (e) {
      print("Error fetching tasks for user $userId: $e");
    }
  }

  Future<void> createTask({
    required String title,
    required String description,
    required int userId,
  }) async {
    try {
      await Client.dio.post(
        '/tasks',
        data: {'title': title, 'description': description, 'user_id': userId},
      );
      await fetchTasksByUserId(userId);
      await fetchAllTasks();
    } catch (e) {
      print("Error creating task for user $userId: $e");
    }
  }

  Future<void> updateTask({
    required int taskId,
    required String status,
    required String role,
    String? comments,
  }) async {
    try {
      if ((role == 'employee' &&
              (status != 'in progress' && status != 'pending')) ||
          (role == 'manager' &&
              (status != 'accepted' && status != 'rejected'))) {
        print("Invalid status update for role $role with status $status");
        return;
      }

      final response = await Client.dio.put(
        '/tasks/$taskId',
        data: {
          'status': status,
          'comments': comments,
        },
      );
      print("Task $taskId updated with status: $status, comments: $comments");
      print("API Response: ${response.data}");

      if (role == 'employee') {
        await fetchTasks();
      } else if (role == 'manager') {
        await fetchAllTasks();
      }

      notifyListeners();
    } catch (e) {
      print("Error updating task $taskId: $e");
    }

    // Clear cached tasks for all users (useful after logout or role switch)
    void clearCache() {
      _tasks.clear();
      _tasksByUser.clear();
      notifyListeners();
    }
  }
}
