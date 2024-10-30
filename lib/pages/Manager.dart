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
  List<Task> tasks = []; // Store tasks here

  final List<Task> initialTasks = [
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
    tasks = List.from(initialTasks); // Initialize with some tasks
    _pages = [
      TaskPage(
        tasks: tasks,
        onUpdate: _updateTask,
        onAdd: _addTask,
      ),
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
          task.comment = comment;
        }
      }
    });
  }

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void _refreshTasks() {
    setState(() {
      // Refresh tasks logic
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'Task Dashboard' : 'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        backgroundColor: Color(0xFFE0E0E0),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(3.0),
          child: Container(
            height: 3.0,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshTasks,
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFE0E0E0),
        child: _pages[_selectedIndex],
      ),
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
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                _showAddTaskDialog(context);
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController employeeNameController =
        TextEditingController();
    DateTime? deadline;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: employeeNameController,
                decoration: InputDecoration(labelText: 'Employee Name'),
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Task Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextButton(
                onPressed: () async {
                  deadline = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2025),
                  );
                },
                child: Text(deadline == null
                    ? 'Select Deadline'
                    : 'Deadline: ${deadline!.toLocal()}'.split(' ')[0]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    employeeNameController.text.isNotEmpty) {
                  final newTask = Task(
                    employeeName: employeeNameController.text,
                    title: titleController.text,
                    description: descriptionController.text,
                    status: 'Assigned',
                    deadline: deadline ?? DateTime.now().add(Duration(days: 7)),
                  );
                  _addTask(newTask);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Please enter employee name and task title.'),
                      backgroundColor: Colors.grey,
                    ),
                  );
                }
              },
              child: Text('Add Task'),
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

class TaskPage extends StatelessWidget {
  final List<Task> tasks;
  final Function(String title, String comment, bool isApproved) onUpdate;
  final Function(Task task) onAdd;

  TaskPage({required this.tasks, required this.onUpdate, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFB0B0E0),
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Employee: ${tasks[index].employeeName}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                SizedBox(height: 8),
                Text('Task Title: ${tasks[index].title}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                SizedBox(height: 4),
                Text('Description: ${tasks[index].description}',
                    style: TextStyle(color: Colors.black)),
                SizedBox(height: 4),
                Text('Status: ${tasks[index].status}',
                    style: TextStyle(color: Colors.black)),
                SizedBox(height: 4),
                Text(
                    'Deadline: ${tasks[index].deadline.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(color: Colors.black)),
                SizedBox(height: 8),
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
      child: Text('Notifications Page'),
    );
  }
}

class Task {
  String employeeName;
  String title;
  String description;
  String status;
  DateTime deadline;
  String? comment;

  Task({
    required this.employeeName,
    required this.title,
    required this.description,
    required this.status,
    required this.deadline,
    this.comment,
  });
}

void main() {
  runApp(MyApp());
}
