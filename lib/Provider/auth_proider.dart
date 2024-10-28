import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/model/user.dart';
import 'package:tasky/services/auth_services.dart';
import 'package:tasky/services/client_services.dart';

// class AuthProvider extends ChangeNotifier {
//   User? user;

//   // Signup method
//   Future<void> signup({
//     required String email,
//     required String password,
//   }) async {
//     user = await AuthServices().registerAPI(email: email, password: password);
//     notifyListeners();

//     Client.dio.options.headers[HttpHeaders.authorizationHeader] =
//         "Bearer ${user!.token}";

//     var prefs = await SharedPreferences.getInstance();
//     prefs.setString('username', user!.username);
//     prefs.setString('token', user!.token);
//   }

// Signin method
// void signin({required User user}) async {
//   token = await AuthServices().signin(user: user);
//   _setToken(token);

//   Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
//   _currentUser = User.fromJson(decodedToken);
//   print("Signed in as: ${_currentUser?.username}");
//   notifyListeners();
// }
// Future<bool> signin(
//     {required String username, required String password}) async {
//   try {
//     var token =
//         await AuthServices().signin(username: username, password: password);
//     await _setToken(token);

//     notifyListeners();
//     return true;
//   } on Exception {
//     return false;
//   }
// }

// Future<bool> isLoggedFromStoreToken() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? storedToken = prefs.getString(tokenKey);
//   if (storedToken == null || storedToken.isEmpty) return false;

//   if (Jwt.isExpired(storedToken)) return false;

//   await _setToken(storedToken);

//   return true;
// }

// // assume token is valid
// Future<void> _setToken(String token) async {
//   Client.dio.options.headers = {
//     HttpHeaders.authorizationHeader: "Bearer $token"
//   };
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setString(tokenKey, token);

//   user = User.fromJson(Jwt.parseJwt(token));
// }

// Future<void> _getToken() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var token = prefs.getString(tokenKey) ?? "";
//   Client.dio.options.headers["authorization"] = "Bearer $token";
//   notifyListeners();
// }

// bool isAuth() => user != null;

// Future<void> initializeAuth() async {
//   await _getToken();
// }

// void logout() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.remove(tokenKey);
//   user = null;
//   notifyListeners();
// }

class AuthProvider extends ChangeNotifier {
  User? user;

  void signupAPI({
    required String email,
    required String password,
  }) async {
    var user = await AuthServices().signupAPI(
      email: email,
      password: password,
    );

    notifyListeners();

    Client.dio.options.headers[HttpHeaders.authorizationHeader] =
        "Bearer ${user.token}";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", user.username);
    prefs.setString("token", user.token);
  }

  Future<void> loginAPI({
    required String email,
    required String password,
  }) async {
    var user = await AuthServices().loginAPI(
      email: email,
      password: password,
    );
    this.user = user;
    notifyListeners();
    Client.dio.options.headers[HttpHeaders.authorizationHeader] =
        "Bearer ${user.token}";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", user.username);
    prefs.setString("token", user.token);
  }
}
