import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky/Provider/auth_proider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // White back arrow
          onPressed: () {
            context.go('/login'); // Navigate to Login page
          },
        ),
        title: const Text(
          "Sign Up",
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
              "Sign Up",
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
            const SizedBox(height: 40),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Handle Sign Up action
                        try {
                          context.read<AuthProvider>().signupAPI(
                                email: usernameController.text,
                                password: passwordController.text,
                              );
                          context.go('/home');
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Something went wrong")),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF062F3E), // Circle button color
                        ),
                        padding:
                            const EdgeInsets.all(16), // Padding around the icon
                        child: const Icon(
                          Icons.app_registration, // Sign Up icon
                          size: 40,
                          color: Colors.white, // Icon color
                        ),
                      ),
                    ),
                    const SizedBox(width: 30), // Spacing between icons
                    GestureDetector(
                      onTap: () {
                        context.go('/login'); // Navigate to Login page
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF062F3E), // Circle button color
                        ),
                        padding:
                            const EdgeInsets.all(16), // Padding around the icon
                        child: const Icon(
                          Icons.login, // Sign In icon
                          size: 40,
                          color: Colors.white, // Icon color
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
