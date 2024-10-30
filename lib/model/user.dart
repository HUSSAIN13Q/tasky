class User {
  String username;
  String token;
  String? role;

  User({
    required this.username,
    required this.token,
    this.role,
  });

  User.fromJson(dynamic json)
      : username = json['user'],
        token = json['token'],
        role = json['role'];

  Map<String, dynamic> toJson() => {
        'user': username,
        'token': token,
        'role': role,
      };
}
