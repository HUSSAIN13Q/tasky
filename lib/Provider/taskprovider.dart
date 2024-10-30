import 'package:flutter/material.dart';
import 'package:tasky/model/task.dart';
import 'package:tasky/services/client_services.dart';

// class TaskProvider with ChangeNotifier {
//   List<Task> _tasks = [];

//   List<Task> get tasks => _tasks;

//   Map<int, List<Task>> _tasksByUser = {};

//   List<Task> tasksByUser(int userId) => _tasksByUser[userId] ?? [];

//  Future<void> fetchTasksByUserId(int userId) async {
//   try {
//     print("Fetching tasks for user ID: $userId");
//     final response = await Client.dio.get('/tasks', queryParameters: {'user_id': userId});
//     print("API Response for user $userId: ${response.data}");

//     if (response.data != null && response.data['data'] != null) {
//       final tasksData = response.data['data']['tasks'] as List;
//       _tasksByUser[userId] = tasksData.map((taskData) => Task.fromJson(taskData)).toList();
//       print("Parsed tasks for user $userId: ${_tasksByUser[userId]?.map((task) => task.title).toList()}");
//       notifyListeners();
//     } else {
//       print("No tasks data found for user $userId.");
//       _tasksByUser[userId] = []; // Ensure empty list if no data found
//     }
//   } catch (e) {
//     print("Error fetching tasks for user $userId: $e");
//   }
// }
//   Future<void> fetchTasks() async {
//     try {
//       final response = await Client.dio.get('/tasks');
//       if (response.data != null && response.data['data'] != null) {
//         final tasksData = response.data['data']['tasks'] as List;

//         _tasks = tasksData.map((taskData) => Task.fromJson(taskData)).toList();
//         notifyListeners();
//       } else {
//         print("No task data found in response.");
//       }
//     } catch (e) {
//       print("Error fetching tasks: $e");
//     }
//   }

//   // Create a new task for a specific user (manager only)
//   Future<void> createTask({
//     required String title,
//     required String description,
//     required int userId,
//   }) async {
//     await Client.dio.post(
//       '/tasks',
//       data: {'title': title, 'description': description, 'user_id': userId},
//     );
//     fetchTasks(); // Refresh tasks list after creation
//   }

//   // Update the status or comments of a task
//   Future<void> updateTask({
//     required int taskId,
//     required String status,
//     String? comments,
//   }) async {
//     await Client.dio.put(
//       '/tasks/$taskId',
//       data: {
//         'status': status,
//         'comments': comments,
//       },
//     );
//     fetchTasks(); // Refresh tasks list after updating
//   }
// }

class TaskProvider with ChangeNotifier {
  List<Task> _tasks =
      []; // All tasks for the currently authenticated user or manager
  Map<int, List<Task>> _tasksByUser = {}; // Stores tasks by employee ID

  List<Task> get tasks => _tasks;
  List<Task> tasksByUser(int userId) => _tasksByUser[userId] ?? [];

  // Fetch all tasks for the manager to review (all employees)
  // Future<void> fetchAllTasks() async {
  //   try {
  //     final response = await Client.dio.get('/tasks');
  //     if (response.data != null && response.data['data'] != null) {
  //       final tasksData = response.data['data']['tasks'] as List;
  //       _tasks = tasksData.map((taskData) => Task.fromJson(taskData)).toList();
  //       notifyListeners();
  //     } else {
  //       print("No task data found in response.");
  //     }
  //   } catch (e) {
  //     print("Error fetching all tasks: $e");
  //   }
  // }
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

  // Fetch tasks for the currently authenticated user (e.g., an employee viewing their own tasks)
  Future<void> fetchTasks() async {
    try {
      final response = await Client.dio
          .get('/tasks'); // Adjust endpoint if needed for user-specific tasks
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

  // Fetch tasks for a specific employee by user ID (used by the manager for individual employee views)
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
        _tasksByUser[userId] = []; // Clear list if no data found
      }
    } catch (e) {
      print("Error fetching tasks for user $userId: $e");
    }
  }

  // Create a new task for a specific user and refresh tasks for that user
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
      await fetchTasksByUserId(userId); // Refresh tasks for specific user
      await fetchAllTasks(); // Refresh the full task list for the manager
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
      // Validate status for employee or manager role
      if ((role == 'employee' &&
              (status != 'in progress' && status != 'pending')) ||
          (role == 'manager' &&
              (status != 'accepted' && status != 'rejected'))) {
        print("Invalid status update for role $role with status $status");
        return;
      }

      // Send update request to the server
      final response = await Client.dio.put(
        '/tasks/$taskId',
        data: {
          'status': status,
          'comments': comments,
        },
      );
      print("Task $taskId updated with status: $status, comments: $comments");
      print("API Response: ${response.data}");

      // Refresh tasks based on role to show updated status
      if (role == 'employee') {
        await fetchTasks(); // Refresh task list for employees
      } else if (role == 'manager') {
        await fetchAllTasks(); // Refresh all tasks for manager
      }

      notifyListeners();
    } catch (e) {
      print("Error updating task $taskId: $e");
    }

    // Future<void> updateTask({
    //   required int taskId,
    //   required String status,
    //   required String role,
    //   String? comments,
    // }) async {
    //   try {
    //     final response = await Client.dio.put(
    //       '/tasks/$taskId',
    //       data: {
    //         'status': status,
    //         'comments': comments,
    //       },
    //     );

    //     // Refresh tasks based on the role to ensure updated comments are shown
    //     if (role == 'manager') {
    //       await fetchAllTasks();
    //     } else {
    //       await fetchTasks(); // Or any specific fetch method for employee tasks
    //     }

    //     notifyListeners();
    //   } catch (e) {
    //     print("Error updating task $taskId: $e");
    //   }
    // }

    // Clear cached tasks for all users (useful after logout or role switch)
    void clearCache() {
      _tasks.clear();
      _tasksByUser.clear();
      notifyListeners();
    }
  }
  // Fetch tasks for the authenticated user
  // Future<void> fetchTasks() async {
  //   final response = await Client.dio.get('/tasks');
  //   _tasks = (response.data['data']['tasks'] as List)
  //       .map((taskData) => Task.fromJson(taskData))
  //       .toList();
  //   notifyListeners();
}
