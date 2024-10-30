import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky/Provider/auth_proider.dart';
import 'package:provider/provider.dart';
import 'package:tasky/pages/Employee.dart';
import 'package:tasky/pages/LeavesPage.dart';
import 'package:tasky/pages/Manager.dart';
import 'package:tasky/pages/notification.dart';
import 'package:tasky/sign/login_page.dart';
import 'package:tasky/sign/signup_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'tsky App',
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF8990FF),
        scaffoldBackgroundColor: Color(0xFFE0E7FF),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF8990FF),
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/manager',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => SignupPage(),
    ),
    GoRoute(
      path: '/employee',
      builder: (context, state) => EmployeePage(),
    ),
    GoRoute(
      path: '/manager',
      builder: (context, state) => ManagerPage(),
    ),
    GoRoute(
      path: '/leaves',
      builder: (context, state) => LeavesPage(),
    ),
    GoRoute(
      path: '/notification',
      builder: (context, state) => NotificationPage(),
    )
  ],
);
