import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky/Provider/auth_proider.dart';

// class SignupPage extends StatefulWidget {
//   SignupPage({Key? key}) : super(key: key);

//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final usernameController = TextEditingController();

//   final passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Sign up"),
//       ),
//       resizeToAvoidBottomInset: false,
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             const Text("Sign Up"),
//             TextField(
//               decoration: const InputDecoration(hintText: 'Username'),
//               controller: usernameController,
//             ),
//             TextField(
//               decoration: const InputDecoration(hintText: 'Password'),
//               controller: passwordController,
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 try {
//                   context.read<AuthProvider>().signup(
//                         email: usernameController.text,
//                         password: passwordController.text,
//                       );
//                   var user = context.read<AuthProvider>().user;
//                   print("You are logged in as ${user!.username}");
//                 } on DioException catch (e) {
//                   if (e.response == null) return;
//                   if (e.response!.data == null) return;

//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       content: Text(
//                           e.response!.data['message'] ?? "Unexpected error")));
//                 }

//                 //context.go('/home');
//               },
//               child: const Text("Sign Up"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
              onPressed: () async {
                try {
                  await context.read<AuthProvider>().signup(
                        email: usernameController.text,
                        password: passwordController.text,
                      );
                  var user = context.read<AuthProvider>().user;
                  print("Signed up and logged in as ${user!.username}");

                  // Navigate based on role
                  if (user.role == 'manager') {
                    context.go('/manager');
                  } else {
                    context.go('/employee');
                  }
                } on DioException catch (e) {
                  if (e.response?.data != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          e.response!.data['message'] ?? "Unexpected error",
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Unexpected error occurred."),
                      ),
                    );
                  }
                }
              },
              child: const Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
