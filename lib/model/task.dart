class Task {
  final int id;
  final int userId;
  final String title;
  final String description;
  String status;
  String? comments;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    this.comments,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      comments: json['comments'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'description': description,
        'status': status,
        'comments': comments,
      };
}
