import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tasky/Provider/taskprovider.dart';
import 'package:tasky/model/task.dart';
import 'package:tasky/sign/signUp_page.dart';

class TaskReviewScreen extends StatefulWidget {
  const TaskReviewScreen({Key? key}) : super(key: key);

  @override
  _TaskReviewScreenState createState() => _TaskReviewScreenState();
}

class _TaskReviewScreenState extends State<TaskReviewScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      Provider.of<TaskProvider>(context, listen: false)
          .fetchAllTasks(); // Fetch all tasks for manager
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Manager Dashboard')),
      body: taskProvider.tasks.isEmpty
          ? const Center(child: Text("No tasks available."))
          : ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final Task task = taskProvider.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Description: ${task.description ?? 'No description'}"),
                      Text("Status: ${task.status}"),
                      if (task.comments != null && task.comments!.isNotEmpty)
                        Text("Comment: ${task.comments!}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => _showStatusUpdateDialog(
                            context, task.id, "accepted"),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => _showStatusUpdateDialog(
                            context, task.id, "rejected"),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  // Method to show a dialog for status update with comment
  void _showStatusUpdateDialog(
      BuildContext context, int taskId, String status) {
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Task Status to $status"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: 'Add a comment',
                  hintText: 'Enter comment...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final comment = commentController.text;

                // Call updateTask with the provided status and comment
                await Provider.of<TaskProvider>(context, listen: false)
                    .updateTask(
                  taskId: taskId,
                  status: status,
                  role: 'manager',
                  comments: comment,
                );

                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Task updated to $status with comment")),
                );
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}


//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_isInitialized) {
//       Provider.of<TaskProvider>(context, listen: false).fetchAllTasks();
//       _isInitialized = true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final taskProvider = Provider.of<TaskProvider>(context);

//     return taskProvider.tasks.isEmpty
//         ? const Center(child: Text("No tasks available."))
//         : ListView.builder(
//             itemCount: taskProvider.tasks.length,
//             itemBuilder: (context, index) {
//               final Task task = taskProvider.tasks[index];
//               return Card(
//                 margin: const EdgeInsets.all(8.0),
//                 child: ListTile(
//                     title: Text(task.title),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                             "Description: ${task.description ?? 'No description'}"),
//                         Text("Status: ${task.status}"),
//                         Text("comments: ${task.comments}"),
//                       ],
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                             icon: Icon(Icons.check, color: Colors.green),
//                             onPressed: () {
//                               _updateTaskStatus(context, task.id, "accepted");
//                               _showStatusUpdateDialog(
//                                   context, task.id, "accepted");
//                             }),
//                         IconButton(
//                             icon: Icon(Icons.close, color: Colors.red),
//                             onPressed: () {
//                               _showStatusUpdateDialog(
//                                   context, task.id, "rejected");
//                               _updateTaskStatus(context, task.id, "rejected");
//                             }),
//                       ],
//                     )),
//               );
//             },
//           );
//   }

//   void _updateTaskStatus(
//       BuildContext context, int taskId, String status) async {
//     await Provider.of<TaskProvider>(context, listen: false).updateTask(
//       taskId: taskId,
//       status: status,
//       role: 'manager',
//     );

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Task status updated to $status")),
//     );
//   }

//   void _showStatusUpdateDialog(
//       BuildContext context, int taskId, String status) {
//     final commentController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Update Task Status to $status"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: commentController,
//                 decoration: const InputDecoration(
//                   labelText: 'Add a comment',
//                   hintText: 'Enter comment...',
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 final comment = commentController.text;

//                 await Provider.of<TaskProvider>(context, listen: false)
//                     .updateTask(
//                   taskId: taskId,
//                   status: status,
//                   role: 'manager',
//                   comments: comment,
//                 );
//                 context.pop();

//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                       content: Text("Task updated to $status with comment")),
//                 );
//               },
//               child: const Text('Submit'),
//             ),
//             TextButton(
//               onPressed: () => context.pop(),
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
