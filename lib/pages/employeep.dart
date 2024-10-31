import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/Provider/taskprovider.dart';
import 'package:tasky/model/notifications.dart';
import 'package:tasky/model/task.dart';

// class EmployeeScreen extends StatefulWidget {
//   const EmployeeScreen({Key? key}) : super(key: key);

//   @override
//   _EmployeeScreenState createState() => _EmployeeScreenState();
// }

// class _EmployeeScreenState extends State<EmployeeScreen> {
//   bool _isInitialized = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_isInitialized) {
//       Provider.of<TaskProvider>(context, listen: false)
//           .fetchTasks(); // Fetch tasks for the employee
//       _isInitialized = true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final taskProvider = Provider.of<TaskProvider>(context);

//     // Define valid status options for employees
//     final employeeStatusOptions = ['in progress', 'pending'];

//     return Scaffold(
//       appBar: AppBar(title: const Text('My Tasks')),
//       body: taskProvider.tasks.isEmpty
//           ? const Center(child: Text("No tasks assigned."))
//           : ListView.builder(
//               itemCount: taskProvider.tasks.length,
//               itemBuilder: (context, index) {
//                 final Task task = taskProvider.tasks[index];

//                 // Check if the task status is valid for employees, if not, set to 'pending' by default
//                 final currentStatus =
//                     employeeStatusOptions.contains(task.status)
//                         ? task.status
//                         : employeeStatusOptions.first;

//                 return ListTile(
//                   title: Text(task.title),
//                   subtitle: Text("Status: ${task.status}"),
//                   trailing: DropdownButton<String>(
//                     value: currentStatus,
//                     items: employeeStatusOptions.map((String status) {
//                       return DropdownMenuItem<String>(
//                         value: status,
//                         child: Text(status),
//                       );
//                     }).toList(),
//                     onChanged: (newStatus) async {
//                       if (newStatus != null) {
//                         await taskProvider.updateTask(
//                           taskId: task.id,
//                           status: newStatus,
//                           role: 'employee',
//                         );
//                       }
//                     },
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/Provider/taskprovider.dart';
import 'package:tasky/Provider/notification_provider.dart';
import 'package:tasky/model/task.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen>
    with SingleTickerProviderStateMixin {
  bool _isInitialized = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      Provider.of<TaskProvider>(context, listen: false)
          .fetchTasks(); // Fetch tasks for the employee
      Provider.of<NotificationProvider>(context, listen: false)
          .fetchNotifications(); // Fetch notifications
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tasks'),
            Tab(text: 'Notifications'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(context),
          _buildNotificationList(context),
        ],
      ),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    // Define valid status options for employees
    final employeeStatusOptions = ['in progress', 'pending'];

    return Scaffold(
        body: taskProvider.tasks.isEmpty
            ? const Center(child: Text("No tasks assigned."))
            : ListView.builder(
                itemCount: taskProvider.tasks.length,
                itemBuilder: (context, index) {
                  final Task task = taskProvider.tasks[index];

                  // Check if the task status is valid for employees, if not, set to 'pending' by default
                  final currentStatus =
                      employeeStatusOptions.contains(task.status)
                          ? task.status
                          : employeeStatusOptions.first;

                  return ListTile(
                    title: Text(task.title),
                    subtitle: Text("Status: ${task.status}"),
                    trailing: DropdownButton<String>(
                      value: currentStatus,
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
                            // final taskProvider = Provider.of<TaskProvider>(context);

                            // return taskProvider.tasks.isEmpty
                            //     ? const Center(child: Text("No tasks assigned."))
                            //     : ListView.builder(
                            //         itemCount: taskProvider.tasks.length,
                            //         itemBuilder: (context, index) {
                            //           final Task task = taskProvider.tasks[index];
                            //           return ListTile(
                            //             title: Text(task.title),
                            //             subtitle: Column(
                            //               crossAxisAlignment: CrossAxisAlignment.start,
                            //               children: [
                            //                 Text("Status: ${task.status}"),
                            //                 if (task.comments != null && task.comments!.isNotEmpty)
                            //                   Text("Manager's Comment: ${task.comments!}"),
                            //               ],
                            //             ),
                            //             trailing: DropdownButton<String>(
                            //               value: task.status,
                            //               items: ['in progress', 'pending'].map((String status) {
                            //                 return DropdownMenuItem<String>(
                            //                   value: status,
                            //                   child: Text(status),
                            //                 );
                            //               }).toList(),
                            //               onChanged: (newStatus) async {
                            //                 if (newStatus != null) {
                            //                   await taskProvider.updateTask(
                            //                     taskId: task.id,
                            //                     status: newStatus,
                            //                     role: 'employee',
                          );
                        }
                      },
                    ),
                  );
                },
              ));
  }

  Widget _buildNotificationList(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return notificationProvider.notifications.isEmpty
        ? const Center(child: Text("No notifications."))
        : ListView.builder(
            itemCount: notificationProvider.notifications.length,
            itemBuilder: (context, index) {
              final NotificationModel notification =
                  notificationProvider.notifications[index];
              return ListTile(
                title: Text(notification.message),
                subtitle: Text("Date: ${notification.createdAt}"),
              );
            },
          );
  }
}
