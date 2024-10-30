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
      title: 'Tasky App',
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF062F3E), // Updated primary color
        scaffoldBackgroundColor: const Color(0xFFE0E7FF), // Background color
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF062F3E), // Updated AppBar color
          titleTextStyle: TextStyle(
            color: Colors.white, // Text color for AppBar title
            fontSize: 20, // Font size
            fontWeight: FontWeight.bold, // Font weight
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Colors.white, // Updated text color for better visibility
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0), // Body text color
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF429094), // Button text color
            padding: const EdgeInsets.symmetric(
                horizontal: 40, vertical: 15), // Button size
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Rounded corners
            ),
          ),
        ),
      ),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/employee',
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
    ),
  ],
);
