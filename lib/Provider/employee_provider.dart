import 'package:flutter/material.dart';
import 'package:tasky/model/leave.dart';
import 'package:tasky/model/task.dart';

class EmployeeProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final List<LeaveRequest> _leaveRequests = [];

  List<Task> get tasks => _tasks;
  List<LeaveRequest> get leaveRequests => _leaveRequests;

  void setTasks(List<Task> tasks) {
    _tasks = tasks;
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTaskStatus(String taskId, String status) {
    final task = _tasks.firstWhere((task) => task.id == taskId);
    task.status = status;
    notifyListeners();
  }

  void addLeaveRequest(LeaveRequest request) {
    _leaveRequests.add(request);
    notifyListeners();
  }

  void updateLeaveRequestStatus(String requestId, String status) {
    final request =
        _leaveRequests.firstWhere((request) => request.id == requestId);
    request.status = status;
    notifyListeners();
  }
}
