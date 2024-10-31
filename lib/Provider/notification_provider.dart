import 'package:flutter/material.dart';
import 'package:tasky/model/notifications.dart';
import 'package:tasky/services/client_services.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications.reversed.toList();

  Future<void> fetchNotifications() async {
    try {
      final response = await Client.dio.get('/notifications');
      if (response.data != null && response.data['data'] != null) {
        final notificationsData =
            response.data['data']['notifications'] as List;
        _notifications = notificationsData.map((notificationData) {
          return NotificationModel.fromJson(notificationData);
        }).toList();
        notifyListeners();
      } else {
        print("No notification data found in response.");
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    }
  }
}
