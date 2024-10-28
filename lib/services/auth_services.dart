import 'package:dio/dio.dart';
import 'package:tasky/services/client_services.dart';

class AuthServices {
  Future<String> signup({
    required String username,
    required String password,
  }) async {
    late String token;
    try {
      Response response = await Client.dio.post('/signup', data: {
        "username": username,
        "password": password,
      });

      token = response.data["token"];
    } on DioError catch (error) {
      print(error);
    }
    return token;
  }

  Future<String> signin(
      {required String username, required String password}) async {
    try {
      Response response = await Client.dio.post('/signin', data: {
        "username": username,
        "password": password,
      });

      return response.data["token"];
    } on DioError catch (error) {
      print(error);
    }
    throw "an eroror occored";
  }
}
