import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tasky/Provider/taskprovider.dart';

import 'package:tasky/model/task.dart';
import 'package:tasky/Provider/employee_provider.dart';

class TaskReviewScreenn extends StatefulWidget {
  const TaskReviewScreenn({Key? key}) : super(key: key);

  @override
  _TaskReviewScreenState createState() => _TaskReviewScreenState();
}

class _TaskReviewScreenState extends State<TaskReviewScreenn> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      Provider.of<TaskProvider>(context, listen: false).fetchAllTasks();
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final employeeProvider = Provider.of<EmployeeProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFE0E7FF),
      body: taskProvider.tasks.isEmpty
          ? const Center(
              child: Text("No tasks available.",
                  style: TextStyle(fontSize: 18, color: Colors.grey)))
          : RefreshIndicator(
              onRefresh: () => taskProvider.fetchAllTasks(),
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: taskProvider.tasks.length,
                itemBuilder: (context, index) {
                  final Task task = taskProvider.tasks[index];
                  final employee =
                      employeeProvider.findEmployeesById(task.userId);
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
                            "Description: ${task.description ?? 'No description'}",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                          Text(
                            "employee: ${employee.username}",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Status: ${task.status}",
                            style: TextStyle(
                              fontSize: 16,
                              color: task.status == 'pending'
                                  ? Colors.orange
                                  : Colors.green,
                            ),
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
                          const SizedBox(height: 15),
                          if (task.shoudShowAp)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _showStatusUpdateDialog(
                                      context, task.id, "accepted"),
                                  icon: Icon(Icons.check, color: Colors.white),
                                  label: Text(
                                    "Accept",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton.icon(
                                  onPressed: () => _showStatusUpdateDialog(
                                      context, task.id, "rejected"),
                                  icon: Icon(Icons.close, color: Colors.white),
                                  label: Text(
                                    "Reject",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  void _showStatusUpdateDialog(
      BuildContext context, int taskId, String status) {
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Task Status to $status"),
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(
              labelText: 'Add a comment',
              hintText: 'Enter comment...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final comment = commentController.text;
                await Provider.of<TaskProvider>(context, listen: false)
                    .updateTask(
                  taskId: taskId,
                  status: status,
                  role: 'manager',
                  comments: comment,
                );
                context.pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Task updated to $status with comment")),
                );
              },
              child: const Text('Submit'),
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
