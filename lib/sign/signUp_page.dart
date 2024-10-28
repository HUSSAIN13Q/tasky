import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditationapp/models/user.dart';
import 'package:meditationapp/providers/auth_proider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky/Provider/auth_proider.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  File? image;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Sign Up"),
            TextField(
              decoration: const InputDecoration(hintText: 'Username'),
              controller: usernameController,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Password'),
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).signup(
                  username: usernameController.text,
                  password: passwordController.text,
                  imagePath: image!.path,
                );
                context.go('/home');
              },
              child: const Text("Sign Up"),
            )
          ],
        ),
      ),
    );
  }
}
