import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tasky/Provider/auth_proider.dart';
import 'package:tasky/pages/employe_pages/leaves_page.dart';
import 'package:tasky/pages/employe_pages/taskpage.dart';
import 'package:tasky/widgets/drawer.dart';
import 'notification_page.dart';

class EmployeePage extends StatefulWidget {
  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    TaskPage(),
    NotificationPage(),
    LeavesPage(),
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
        appBarTitle = 'Your Tasks';
        break;
      case 1:
        appBarTitle = 'Notifications';
        break;
      case 2:
        appBarTitle = 'Leaves';
        break;
      default:
        appBarTitle = 'Your Tasks';
    }

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF062F3E),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 3.0,
              ),
            ),
          ),
          child: AppBar(
              backgroundColor: Color(0xFF062F3E),
              title: Text(
                appBarTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
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
        ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.beach_access),
            label: 'Leaves',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
