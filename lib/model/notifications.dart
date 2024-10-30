class NotificationModel {
  final int id;
  final int userId;
  final String message;
  final String type;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.message,
    required this.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      message: json['message'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'message': message,
        'type': type,
      };
}
