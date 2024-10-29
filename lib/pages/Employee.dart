import 'package:flutter/material.dart';
import 'LeavesPage.dart';
import 'package:go_router/go_router.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee App',
      home: EmployeePage(),
    );
  }
}

class EmployeePage extends StatefulWidget {
  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  int _selectedIndex = 0;

  // List to hold tasks assigned to the employee
  List<Task> tasks = [
    Task(
      title: 'Complete Report',
      description: 'Finish the annual report',
      state: 'Assigned',
      comment: null,
    ),
    Task(
      title: 'Prepare Presentation',
      description: 'Prepare slides for the meeting',
      state: 'In Progress',
      comment: null,
    ),
  ];

  final List<Widget> _pages;

  _EmployeePageState()
      : _pages = [
          TaskPage(), // Default page showing tasks
          NotificationsPage(), // Notifications page
          LeavesPage(), // Leaves page
        ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Dashboard'),
      ),
      body: _pages[_selectedIndex], // Displays the selected page
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
          BottomNavigationBarItem(
            icon: Icon(Icons.beach_access), // Leaves icon
            label: 'Leaves',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Updates the selected index
      ),
    );
  }
}

class TaskPage extends StatelessWidget {
  final List<Task> tasks = [
    Task(
      title: 'Complete Report',
      description: 'Finish the annual report',
      state: 'Assigned',
      comment: null,
    ),
    Task(
      title: 'Prepare Presentation',
      description: 'Prepare slides for the meeting',
      state: 'In Progress',
      comment: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Text(tasks[index].title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tasks[index].description),
                Text('Status: ${tasks[index].state}'),
                if (tasks[index].comment != null)
                  Text('Manager Comment: ${tasks[index].comment}'),
              ],
            ),
          ),
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

// Task model for tasks assigned to employees
class Task {
  String title;
  String description;
  String state;
  String? comment; // Optional comment field

  Task({
    required this.title,
    required this.description,
    required this.state,
    this.comment, // Initialize as null
  });
}
