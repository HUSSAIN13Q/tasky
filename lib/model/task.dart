class Task {
  final String id;
  final String title;
  final String description;
  late final String
      status; // e.g., "not started", "in progress", "done", "pending", "accepted", "denied"
  late final String? managerComments; // Comments if a redo is requested

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.status = 'not started',
    this.managerComments,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'managerComments': managerComments,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: map['status'],
      managerComments: map['managerComments'],
    );
  }
}
