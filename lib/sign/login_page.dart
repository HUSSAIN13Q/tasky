// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tasky/Provider/auth_proider.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Login"),
//       ),
//       resizeToAvoidBottomInset: false,
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             const Text("Login"),
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
//               onPressed: () async {
//                 try {
//                   await context.read<AuthProvider>().loginAPI(
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
//               child: const Text("Login"),
//             ),
//             SizedBox(
//               height: 22,
//             ),

//           ],
//         ),
//       ),
//     );
//   }
// }
// lib/screens/login_page.dart

import 'package:dio/dio.dart';
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
        title: const Text("Login"),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Login"),
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
            // ElevatedButton(
            //   onPressed: () async {
            //     try {
            //       await context.read<AuthProvider>().loginAPI(
            //             email: usernameController.text,
            //             password: passwordController.text,
            //           );
            //       var user = context.read<AuthProvider>().user;
            //       print("You are logged in as ${user!.username}");

            //       // Navigate based on role
            //       if (user.role == 'manager') {
            //         context.go('/manager');
            //       } else {
            //         context.go('/employee');
            //       }
            //     } on DioException catch (e) {
            //       if (e.response == null || e.response!.data == null) return;
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(
            //           content: Text(
            //               e.response!.data['message'] ?? "Unexpected error"),
            //         ),
            //       );
            //     }
            //   },
            //   child: const Text("Login"),
            // ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await context.read<AuthProvider>().loginAPI(
                        email: usernameController.text,
                        password: passwordController.text,
                      );
                  var user = context.read<AuthProvider>().user;

                  if (user != null) {
                    // Navigate based on role
                    if (user.role == 'manager') {
                      context.go('/manager');
                    } else {
                      context.go('/employee');
                    }
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Login failed: ${e.toString()}")),
                  );
                }
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
