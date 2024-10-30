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

  // Refresh function (add your implementation here if needed)
  void _refreshContent() {
    // Implement refresh logic if necessary
    setState(() {
      // For example, if you need to refresh the task list or notifications
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0), // Height of the AppBar
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFE0E0E0), // Set AppBar background color
            border: Border(
              bottom: BorderSide(
                color: Colors.grey, // Border color
                width: 3.0, // Increased border width for a bolder appearance
              ),
            ),
          ),
          child: AppBar(
            backgroundColor:
                Colors.transparent, // Make AppBar background transparent
            title: Text(
              'Tasks',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800], // Ensure text is visible
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.refresh,
                  color: Colors.grey[800]), // Refresh button in dark grey
              onPressed: _refreshContent, // Calls the refresh function on press
            ),
          ),
        ),
      ),
      body: Container(
        color: Color(0xFFE0E0E0), // Light grey background for the body
        child: _pages[_selectedIndex], // Displays the selected page
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

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
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

  List<bool> isStarted = List<bool>.filled(2, false);
  List<bool> isNotStarted = List<bool>.filled(2, false);
  List<bool> isDone = List<bool>.filled(2, false);

  void _submitStatus(int index) {
    String status = 'Task "${tasks[index].title}" status: ';
    if (isStarted[index]) {
      status += 'Started';
    } else if (isNotStarted[index]) {
      status += 'Not Started';
    } else if (isDone[index]) {
      status += 'Done';
    } else {
      // Show default SnackBar alert if no checkbox is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a status before submitting.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.grey,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return; // Exit the function if no status is selected
    }

    // Display a SnackBar to show submission status
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Submitted! You did it!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.grey,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Reset checkbox states after submission
    setState(() {
      isStarted[index] = false;
      isNotStarted[index] = false;
      isDone[index] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFE0E0E0), // Light grey background
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFB0B0E0), // Lighter shade of blue
                    Colors.white, // Light shade (white)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.all(16.0),
              child: ListTile(
                title: Text(
                  tasks[index].title,
                  style: TextStyle(
                    color: Colors.grey[800], // Changed task text to dark grey
                    fontSize: 24,
                    fontWeight: FontWeight.w600, // Lora 600
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tasks[index].description,
                      style: TextStyle(
                        color: Colors
                            .grey[800], // Changed description text to dark grey
                        fontSize: 20,
                        fontWeight: FontWeight.w600, // Lora 600
                      ),
                    ),
                    Text(
                      'Status: ${tasks[index].state}',
                      style: TextStyle(
                        color: Colors
                            .grey[800], // Changed status text to dark grey
                        fontSize: 20,
                        fontWeight: FontWeight.w600, // Lora 600
                      ),
                    ),
                    if (tasks[index].comment != null)
                      Text(
                        'Manager Comment: ${tasks[index].comment}',
                        style: TextStyle(
                          color: Colors
                              .grey[800], // Changed comment text to dark grey
                          fontSize: 20,
                          fontWeight: FontWeight.w600, // Lora 600
                        ),
                      ),
                    // Checkboxes and Submit button
                    Row(
                      children: [
                        Checkbox(
                          value: isStarted[index],
                          onChanged: (value) {
                            setState(() {
                              isStarted[index] = value!;
                              if (value) {
                                isNotStarted[index] = false;
                                isDone[index] = false;
                              }
                            });
                          },
                        ),
                        Text('Started',
                            style: TextStyle(
                              color: Colors.grey[
                                  800], // Changed checkbox label text to dark grey
                              fontSize: 20,
                              fontWeight: FontWeight.w600, // Lora 600
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isNotStarted[index],
                          onChanged: (value) {
                            setState(() {
                              isNotStarted[index] = value!;
                              if (value) {
                                isStarted[index] = false;
                                isDone[index] = false;
                              }
                            });
                          },
                        ),
                        Text('Not Started',
                            style: TextStyle(
                              color: Colors.grey[
                                  800], // Changed checkbox label text to dark grey
                              fontSize: 20,
                              fontWeight: FontWeight.w600, // Lora 600
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isDone[index],
                          onChanged: (value) {
                            setState(() {
                              isDone[index] = value!;
                              if (value) {
                                isStarted[index] = false;
                                isNotStarted[index] = false;
                              }
                            });
                          },
                        ),
                        Text('Done',
                            style: TextStyle(
                              color: Colors.grey[
                                  800], // Changed checkbox label text to dark grey
                              fontSize: 20,
                              fontWeight: FontWeight.w600, // Lora 600
                            )),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => _submitStatus(index),
                      child: Text('Submit Status',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800] // Lora 600
                              )),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFE0E0E0), // Light grey background
      child: Center(
        child: Text(
          'No Notifications',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class Task {
  final String title;
  final String description;
  final String state;
  final String? comment;

  Task({
    required this.title,
    required this.description,
    required this.state,
    this.comment,
  });
}

void main() {
  runApp(MyApp());
}
