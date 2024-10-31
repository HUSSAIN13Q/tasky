import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tasky/Provider/auth_proider.dart';
import 'package:tasky/pages/manager_page/review.dart';
import 'package:tasky/pages/task_manager.dart';
import 'manager_screen.dart';

class ManagerDashboard extends StatefulWidget {
  @override
  _ManagerDashboardState createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ManagerScreen(),
    TaskReviewScreenn(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _refreshContent() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle;
    switch (_selectedIndex) {
      case 0:
        appBarTitle = 'Manage Employees';
        break;
      case 1:
        appBarTitle = 'Task Review';
        break;
      default:
        appBarTitle = 'Manager Dashboard';
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
            appBarTitle,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Color(0xFF062F3E),
          leading: IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshContent,
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    context.read<AuthProvider>().logout();
                    context.go('/login');
                  },
                  child: Icon(
                    Icons.logout_rounded,
                    size: 26.0,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                )),
          ]),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Employees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            label: 'Tasks',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF062F3E),
        onTap: _onItemTapped,
      ),
    );
  }
}
