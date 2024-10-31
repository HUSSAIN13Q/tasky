import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/Provider/notification_provider.dart';
import 'package:intl/intl.dart';
import 'package:tasky/model/notifications.dart';

class NotificationPage extends StatelessWidget {
  String formatDateTime(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    String formattedTime = DateFormat('HH:mm').format(parsedDate);
    return "$formattedDate at $formattedTime";
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final notifications = notificationProvider.notifications;

    return Scaffold(
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                "No notifications.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => notificationProvider.fetchNotifications(),
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final NotificationModel notification = notifications[index];
                  return Card(
                    elevation: 4,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFF8990FF),
                        child: Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF062F3E),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          formatDateTime(notification.createdAt.toString()),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
