import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tasky/Provider/employee_provider.dart';
import 'package:tasky/Provider/taskprovider.dart';

class ManagerScreen extends StatefulWidget {
  const ManagerScreen({Key? key}) : super(key: key);

  @override
  _ManagerScreenState createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      Provider.of<EmployeeProvider>(context, listen: false).fetchEmployees();
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFE0E7FF),
      body: employeeProvider.employees.isEmpty
          ? const Center(
              child: Text("No employees available.",
                  style: TextStyle(fontSize: 18, color: Colors.grey)))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: employeeProvider.employees.length,
              itemBuilder: (context, index) {
                final employee = employeeProvider.employees[index];
                return Card(
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      employee.username,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(employee.role ?? 'No role assigned'),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 76, 175, 80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Assign Task",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () =>
                          _showCreateTaskDialog(context, employee.id),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showCreateTaskDialog(BuildContext context, int userId) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (titleController.text.isEmpty ||
                    descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please fill out all fields.")),
                  );
                  return;
                }

                await Provider.of<TaskProvider>(context, listen: false)
                    .createTask(
                  title: titleController.text,
                  description: descriptionController.text,
                  userId: userId,
                );

                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Task created successfully.")),
                );
              },
              child: const Text('Create Task'),
            ),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
