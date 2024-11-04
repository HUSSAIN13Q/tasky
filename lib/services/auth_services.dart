import 'package:dio/dio.dart';
import 'package:tasky/model/user.dart';
import 'package:tasky/services/client_services.dart';

class AuthServices {
  Future<User> signupAPI({
    required String email,
    required String password,
  }) async {
    Response response = await Client.dio.post('/signup', data: {
      "email": email,
      "password": password,
    });
    if (response.statusCode != 200) {
      throw response.data is Map
          ? response.data['message']
          : "Unexpected server error";
    }

    if (response.statusCode != 200) {
      throw "not good";
    }
    var user = User.fromJson(response.data['data']);
    print(response.statusCode);

    return user;
  }

  Future<User> loginAPI({
    required String email,
    required String password,
  }) async {
    Response response = await Client.dio.post('/login', data: {
      "email": email,
      "password": password,
    });
    if (response.statusCode != 200) {
      throw response.data is Map
          ? response.data['message']
          : "Unexpected server error";
    }
    return User.fromJson(response.data['data']);
  }
}
