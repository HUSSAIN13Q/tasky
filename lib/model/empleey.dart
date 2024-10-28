import 'leave.dart';
import 'task.dart';

class Employee {
  final String id; // Unique identifier for the employee
  final String name; // Employee's name
  final String role; // Role, which in this case would be "Employee"
  final List<String> skills; // List of skills like ["Flutter", "UI"]
  final List<Task> tasks; // List of tasks assigned to the employee
  final List<LeaveRequest>
      leaveRequests; // List of leave requests by the employee

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.skills,
    this.tasks = const [],
    this.leaveRequests = const [],
  });

  // Convert Employee instance to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'skills': skills,
      'tasks': tasks.map((task) => task.toMap()).toList(),
      'leaveRequests': leaveRequests.map((leave) => leave.toMap()).toList(),
    };
  }

  // Factory constructor to create an Employee instance from a map
  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      role: map['role'],
      skills: List<String>.from(map['skills']),
      tasks: map['tasks'] != null
          ? List<Task>.from(map['tasks'].map((task) => Task.fromMap(task)))
          : [],
      leaveRequests: map['leaveRequests'] != null
          ? List<LeaveRequest>.from(
              map['leaveRequests'].map((leave) => LeaveRequest.fromMap(leave)))
          : [],
    );
  }
}
