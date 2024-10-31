import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/Provider/auth_proider.dart';
import 'package:tasky/Provider/employee_provider.dart';
import 'package:tasky/Provider/taskprovider.dart';
import 'package:tasky/model/task.dart';

class TaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final userId = context.read<AuthProvider>().user!.username;
    final employeeId =
        context.read<EmployeeProvider>().findEmployeesByUasername(userId);
    final employeeStatusOptions = ['in progress', 'pending'];

    return Scaffold(
      body: taskProvider.tasks.isEmpty
          ? const Center(
              child: Text("No tasks assigned.",
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
            )
          : RefreshIndicator(
              onRefresh: () => taskProvider.fetchTasksByUserId(employeeId.id),
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: taskProvider.tasks.length,
                itemBuilder: (context, index) {
                  final Task task = taskProvider.tasks[index];

                  final currentStatus =
                      employeeStatusOptions.contains(task.status)
                          ? task.status
                          : employeeStatusOptions.first;

                  return Card(
                    elevation: 4,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF062F3E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Status: ${task.status}",
                            style: TextStyle(
                              fontSize: 16,
                              color: task.status == 'pending'
                                  ? Colors.orange
                                  : Colors.blue,
                            ),
                          ),
                          Text(
                            "Description: ${task.description ?? 'No description'}",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                          if (task.comments != null &&
                              task.comments!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Comment: ${task.comments!}",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600]),
                              ),
                            ),
                          const SizedBox(height: 8),
                          DropdownButton<String>(
                            value: currentStatus,
                            icon: Icon(Icons.arrow_drop_down,
                                color: Color(0xFF062F3E)),
                            items: employeeStatusOptions.map((String status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                            onChanged: (newStatus) async {
                              if (newStatus != null) {
                                await taskProvider.updateTask(
                                  taskId: task.id,
                                  status: newStatus,
                                  role: 'employee',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Task updated to $newStatus"),
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
