import 'dart:io';
import 'package:dio/dio.dart';
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

// class AuthProvider extends ChangeNotifier {
//   User? user;

//   void signup({
//     required String email,
//     required String password,
//   }) async {
//     var user = await AuthServices().signupAPI(
//       email: email,
//       password: password,
//     );

//     notifyListeners();

//     Client.dio.options.headers[HttpHeaders.authorizationHeader] =
//         "Bearer ${user.token}";

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString("user", user.username);
//     prefs.setString("token", user.token);
//   }

//   Future<void> loginAPI({
//     required String email,
//     required String password,
//   }) async {
//     var user = await AuthServices().loginAPI(
//       email: email,
//       password: password,
//     );
//     this.user = user;
//     notifyListeners();
//     Client.dio.options.headers[HttpHeaders.authorizationHeader] =
//         "Bearer ${user.token}";

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString("user", user.username);
//     prefs.setString("token", user.token);
//   }

//   Future<void> loadPreviousUser() async {
//     // read from shared
//     var prefs = await SharedPreferences.getInstance();
//     var username = prefs.getString("username");
//     var token = prefs.getString("token");

//     if (username == null || token == null) {
//       prefs.remove("username");
//       prefs.remove("token");
//       return;
//     }

//     user = User(token: token, username: username);

//     Client.dio.options.headers[HttpHeaders.authorizationHeader] =
//         "Bearer ${user!.token}";
//     // assign in state
//     notifyListeners();
//   }

//    Future<void> logout() async {
//     user = null;
//     Client.dio.options.headers.remove(HttpHeaders.authorizationHeader);
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     notifyListeners();
//   }
// }

class AuthProvider extends ChangeNotifier {
  User? user;
  final tokenKey = "token";

  Future<void> signup({
    required String email,
    required String password,
  }) async {
    user = await AuthServices().signupAPI(email: email, password: password);
    notifyListeners();

    // Set authorization header
    Client.dio.options.headers[HttpHeaders.authorizationHeader] =
        "Bearer ${user!.token}";

    // Save user data to shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("username", user!.username);
    prefs.setString("token", user!.token);
  }

  Future<void> loginAPI({
    required String email,
    required String password,
  }) async {
    try {
      user = await AuthServices().loginAPI(
        email: email,
        password: password,
      );

      // Set the authorization header
      Client.dio.options.headers[HttpHeaders.authorizationHeader] =
          "Bearer ${user!.token}";

      // Save user data in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("username", user!.username);
      prefs.setString("token", user!.token);

      notifyListeners();
    } on DioException catch (e) {
      print("DioException in loginAPI: ${e.response?.data ?? e.message}");
      throw e; // Re-throwing the exception to be handled in the UI
    } catch (e) {
      print("Unexpected error in loginAPI: $e");
      throw Exception("An unexpected error occurred during login.");
    }
  }

  Future<void> loadPreviousUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString("username");
    var token = prefs.getString("token");
    var id = prefs.getInt("id");

    if (username == null || token == null || id == null) {
      prefs.remove("username");
      prefs.remove("token");
      prefs.remove("id");
      return;
    }

    user = User(username: username, token: token);

    Client.dio.options.headers[HttpHeaders.authorizationHeader] =
        "Bearer ${user!.token}";
    notifyListeners();
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(tokenKey);
    user = null;
    notifyListeners();
  }
}
