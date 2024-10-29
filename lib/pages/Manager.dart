import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manager App',
      home: ManagerPage(),
    );
  }
}

class ManagerPage extends StatefulWidget {
  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  int _selectedIndex = 0;

  // Sample list to hold tasks assigned to employees
  final List<Task> tasks = [
    Task(
      employeeName: 'John Doe',
      title: 'Assign Team Project',
      description: 'Project due next week',
      status: 'Assigned',
      deadline: DateTime.now().add(Duration(days: 5)),
    ),
    Task(
      employeeName: 'Jane Smith',
      title: 'Review Reports',
      description: 'Weekly reports to be reviewed',
      status: 'In Progress',
      deadline: DateTime.now().add(Duration(days: 2)),
    ),
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      TaskPage(
          tasks: tasks, onUpdate: _updateTask), // Default page showing tasks
      NotificationsPage(), // Notifications page
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _updateTask(String title, String comment, bool isApproved) {
    setState(() {
      for (var task in tasks) {
        if (task.title == title) {
          task.status = isApproved ? 'Approved' : 'Denied';
          task.comment = comment; // Save comment
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manager Dashboard'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class TaskPage extends StatelessWidget {
  final List<Task> tasks;
  final Function(String title, String comment, bool isApproved) onUpdate;

  TaskPage({required this.tasks, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Employee: ${tasks[index].employeeName}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Task Title: ${tasks[index].title}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Description: ${tasks[index].description}'),
                SizedBox(height: 4),
                Text('Status: ${tasks[index].status}'),
                SizedBox(height: 4),
                Text(
                    'Deadline: ${tasks[index].deadline.toLocal().toString().split(' ')[0]}'),
                SizedBox(height: 8),
                ButtonBar(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _showCommentDialog(context, tasks[index].title, true);
                      },
                      child: Text('Approve'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showCommentDialog(context, tasks[index].title, false);
                      },
                      child: Text('Deny'),
                    ),
                  ],
                ),
                if (tasks[index].comment != null)
                  Text('Comment: ${tasks[index].comment}',
                      style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCommentDialog(BuildContext context, String title, bool isApproved) {
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isApproved ? 'Approve Task' : 'Deny Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: commentController,
                decoration: InputDecoration(labelText: 'Comment'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                onUpdate(title, commentController.text, isApproved);
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Notifications',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Text('You have no new notifications.',
              style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}

// Task model to represent each task
class Task {
  String employeeName;
  String title;
  String description;
  String status;
  DateTime deadline;
  String? comment; // Optional comment field

  Task({
    required this.employeeName,
    required this.title,
    required this.description,
    required this.status,
    required this.deadline,
    this.comment, // Initialize as null
  });
}
