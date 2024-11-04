import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/model/user.dart';
import 'package:tasky/services/auth_services.dart';
import 'package:tasky/services/client_services.dart';

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
