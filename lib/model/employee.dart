class Employee {
  final int id;
  final String username;
  final String? role;

  Employee({
    required this.id,
    required this.username,
    this.role,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      username: json['email'] ?? 'No username provided',
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'role': role,
      };
}
