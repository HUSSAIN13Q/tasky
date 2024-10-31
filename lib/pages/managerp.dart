import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tasky/Provider/employee_provider.dart';
import 'package:tasky/Provider/taskprovider.dart';
import 'package:tasky/model/employee.dart';
import 'package:tasky/model/task.dart';
import 'package:tasky/model/user.dart';

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
      body: employeeProvider.employees.isEmpty
          ? const Center(child: Text("No employees available."))
          : ListView.builder(
              itemCount: employeeProvider.employees.length,
              itemBuilder: (context, index) {
                final Employee employee = employeeProvider.employees[index];
                return ListTile(
                  title: Text(employee.username), // Display username
                  subtitle:
                      Text(employee.role ?? 'No role assigned'), // Display role
                  onTap: () {
                    // Show dialog to assign task
                    _showCreateTaskDialog(context, employee.id);
                  },
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

                // Use TaskProvider to create a task for the selected employee
                await Provider.of<TaskProvider>(context, listen: false)
                    .createTask(
                  title: titleController.text,
                  description: descriptionController.text,
                  userId: userId,
                );

                // Close the dialog with GoRouter
                context.pop(); // Closes the dialog

                // Optional: Show success message after closing dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Task created successfully.")),
                );
              },
              child: const Text('Create Task'),
            ),
            TextButton(
              onPressed: () => context.pop(), // Closes the dialog with GoRouter
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
// class ManagerScreen extends StatefulWidget {
//   const ManagerScreen({Key? key}) : super(key: key);

//   @override
//   _ManagerScreenState createState() => _ManagerScreenState();
// }

// class _ManagerScreenState extends State<ManagerScreen> {
//   bool _isInitialized = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_isInitialized) {
//       Provider.of<EmployeeProvider>(context, listen: false).fetchEmployees();
//       _isInitialized = true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final employeeProvider = Provider.of<EmployeeProvider>(context);
//     final taskProvider = Provider.of<TaskProvider>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Manager Dashboard')),
//       body: employeeProvider.employees.isEmpty
//           ? const Center(child: Text("No employees available."))
//           : ListView.builder(
//               itemCount: employeeProvider.employees.length,
//               itemBuilder: (context, index) {
//                 final Employee employee = employeeProvider.employees[index];
//                 return ExpansionTile(
//                   title: Text(employee.username),
//                   subtitle: Text(employee.role ?? 'No role assigned'),
//                   onExpansionChanged: (isExpanded) {
//                     if (isExpanded) {
//                       taskProvider.fetchTasksByUserId(
//                           employee.id); // Fetch tasks for this employee
//                     }
//                   },
//                   children:
//                       _buildTaskList(taskProvider.tasksByUser(employee.id)),
//                 );
//               },
//             ),
//     );
//   }

//   List<Widget> _buildTaskList(List<Task> tasks) {
//     print(
//         "Building task list for employee: ${tasks.map((task) => task.title).toList()}");
//     if (tasks.isEmpty) {
//       return [const ListTile(title: Text("No tasks assigned."))];
//     }
//     return tasks.map((task) {
//       return ListTile(
//         title: Text(task.title),
//         subtitle: Text("Status: ${task.status}"),
//       );
//     }).toList();
//   }
// }
