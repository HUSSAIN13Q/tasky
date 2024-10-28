import 'leave.dart';
import 'task.dart';

class Employee {
  final String id;
  final String name;
  final String role;
  final List<String> skills;
  final List<Task> tasks;
  final List<LeaveRequest> leaveRequests;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.skills,
    this.tasks = const [],
    this.leaveRequests = const [],
  });

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
