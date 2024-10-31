import 'package:flutter/material.dart';
import 'package:tasky/model/employee.dart';
import 'package:tasky/model/user.dart';
import 'package:tasky/services/client_services.dart';

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

  Employee findEmployeesById(int id) {
    return _employees.firstWhere((emp) => emp.id == id);
  }

  Employee findEmployeesByUasername(String username) {
    return _employees.firstWhere((emp) => emp.username == username);
  }
}
