import 'package:flutter/material.dart';
import 'package:tasky/model/employee.dart';
import 'package:tasky/model/user.dart';
import 'package:tasky/services/client_services.dart';

// class UserProvider with ChangeNotifier {
//   List<User> _users = [];

//   List<User> get users => _users;

//   Future<void> fetchUsers() async {
//     try {
//       final response = await Client.dio.get('/employees');
//       if (response.data != null && response.data['data'] != null) {
//         final employeesData = response.data['data']['employees'];

//         // Ensure employeesData is a list and map each item to a User
//         if (employeesData is List) {
//           _users =
//               employeesData.map((userData) => User.fromJson(userData)).toList();
//         } else {
//           print("Expected a list of employees, but got: $employeesData");
//         }

//         notifyListeners(); // Notify listeners to update the UI
//       } else {
//         print("No data found in response.");
//       }
//     } catch (e) {
//       print("Error fetching users: $e");
//       // Handle error, possibly notify listeners with error state
//     }
//   }
// }
// class UserProvider with ChangeNotifier {
//   List<User> _users = [];

//   List<User> get users => _users;

//   Future<void> fetchUsers() async {
//     try {
//       final response = await Client.dio.get('/employees');
//       if (response.data != null && response.data['data'] != null) {
//         final employeesData = response.data['data']['employees'] as List;

//         _users =
//             employeesData.map((userData) => User.fromJson(userData)).toList();
//         notifyListeners(); // Notify UI to update
//       } else {
//         print("No employee data found in response.");
//       }
//     } catch (e) {
//       print("Error fetching users: $e");
//     }
//   }
// }
class EmployeeProvider with ChangeNotifier {
  List<Employee> _employees = [];

  List<Employee> get employees => _employees;

  Future<void> fetchEmployees() async {
    try {
      final response = await Client.dio.get('/employees');
      final employeesData = response.data['data']['employees'] as List;

      _employees = employeesData
          .map((employeeData) => Employee.fromJson(employeeData))
          .toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching employees: $e");
    }
  }
}
