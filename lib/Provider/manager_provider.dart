import 'package:flutter/material.dart';
import 'package:tasky/model/empleey.dart';
import 'package:tasky/model/leave.dart';
import 'package:tasky/model/task.dart';

class ManagerProvider with ChangeNotifier {
  List<Employee> _employees = [];
  List<Task> _pendingTasks = [];
  List<LeaveRequest> _pendingLeaveRequests = [];

  List<Employee> get employees => _employees;
  List<Task> get pendingTasks => _pendingTasks;
  List<LeaveRequest> get pendingLeaveRequests => _pendingLeaveRequests;

  void setEmployees(List<Employee> employees) {
    _employees = employees;
    notifyListeners();
  }

  List<Employee> filterEmployeesBySkills(List<String> selectedSkills) {
    return _employees.where((employee) {
      return selectedSkills.every((skill) => employee.skills.contains(skill));
    }).toList();
  }

  void assignTask(Employee employee, Task task) {
    employee.tasks.add(task);
    notifyListeners();
  }

  void updateTaskStatus(Task task, String status, {String? managerComments}) {
    task.status = status;
    task.managerComments = managerComments;
    notifyListeners();
  }

  void updateLeaveRequestStatus(LeaveRequest request, String status) {
    request.status = status;
    notifyListeners();
  }
}
