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
      // appBar: AppBar(
      //   backgroundColor: Color(0xFF2E2D7D), // Change to your preferred color
      //   title: Text(
      //     'Notifications', // Title can be changed based on the page name
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       color: Colors.white, // Set text color to white
      //     ),
      //   ),
      //   leading: IconButton(
      //     icon: Icon(Icons.refresh, color: Colors.white), // Refresh button
      //     onPressed:
      //         _refreshNotifications, // Calls the refresh function on press
      //   ),
      // ),
      body: Container(
        color: Color(0xFFE0E0E0), // Set the background color here
        child: RefreshIndicator(
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
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(
                                0xFFB0B0E0), // First color of the gradient (light blue)
                            Colors
                                .white, // Second color of the gradient (white)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notifications[index],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'This is a description for ${notifications[index]}.', // Sample description
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                onPressed: () {
                                  // Handle notification action
                                },
                                child: Text(
                                  'View More',
                                  style: TextStyle(
                                    color: Color(0xFF2E2D7D), // Action color
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
