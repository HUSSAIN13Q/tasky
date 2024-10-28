class User {
  String username;
  String token;

  User({
    required this.username,
    required this.token,
  });

  User.fromJson(dynamic json)
      : username = json['user'],
        token = json['token'];

  Map<String, dynamic> toJson() => {
        'user': username,
        'token': token,
      };
}
