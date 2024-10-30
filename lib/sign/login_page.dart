import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky/Provider/auth_proider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.white), // AppBar text color
        ),
        backgroundColor: const Color(0xFF062F3E), // AppBar background color
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Login",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062F3E), // Text color
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Username',
                border: OutlineInputBorder(),
              ),
              controller: usernameController,
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
              ),
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await context.read<AuthProvider>().loginAPI(
                        email: usernameController.text,
                        password: passwordController.text,
                      );
                  context.go('/home');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF429094), // Text color
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
              ),
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 18), // Button text style
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: () {
                context.push('/signup');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    const Color(0xFF429094), // Text color (same as Login)
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 15), // Same size
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(fontSize: 18), // Button text style
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await context.read<AuthProvider>().loginAPI(
                  email: usernameController.text,
                  password: passwordController.text,
                );
            context.go('/home');
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        },
        backgroundColor: const Color(0xFF429094), // Floating button color
        child: const Icon(Icons.login), // Icon for floating button
      ),
    );
  }
}
