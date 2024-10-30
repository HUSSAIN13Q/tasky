import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Simulated list of notifications
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications(); // Initial fetch of notifications
  }

  // Simulated function to fetch notifications
  Future<void> _fetchNotifications() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    setState(() {
      notifications = [
        'Notification 1',
        'Notification 2',
        'Notification 3',
      ]; // Sample notifications
    });
  }

  // Refresh function for pull-to-refresh
  Future<void> _refreshNotifications() async {
    await _fetchNotifications(); // Fetch notifications again
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2D7D), // Change to your preferred color
        title: Text(
          'Notification',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Set text color to white
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.refresh, color: Colors.white), // Refresh button
          onPressed:
              _refreshNotifications, // Calls the refresh function on press
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications, // Enables pull-to-refresh gesture
        child: notifications.isEmpty
            ? Center(
                child: Text(
                  'You have no new notifications.',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(notifications[index]),
                  );
                },
              ),
      ),
    );
  }
}
