import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky/Provider/auth_proider.dart';
import 'package:provider/provider.dart';
import 'package:tasky/Provider/employee_provider.dart';
import 'package:tasky/Provider/notification_provider.dart';
import 'package:tasky/Provider/taskprovider.dart';
import 'package:tasky/pages/employe_pages/emplyee_screen.dart';
import 'package:tasky/pages/manager_page/manager_dashboard.dart';
import 'package:tasky/sign/login_page.dart';
import 'package:tasky/sign/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var authProvider = AuthProvider();
  await authProvider.loadPreviousUser();

  var initRoute = "/login";

  if (authProvider.user != null) {
    initRoute =
        authProvider.user!.role == "employee" ? "/employee" : "/manager";
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()..fetchTasks()),
        ChangeNotifierProvider(
            create: (_) => NotificationProvider()..fetchNotifications()),
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
        primaryColor: const Color(0xFF062F3E),
        scaffoldBackgroundColor: const Color(0xFFE0E7FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF062F3E),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF429094),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/signup',
      builder: (context, state) => SignupPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/manager',
      builder: (context, state) => ManagerDashboard(),
    ),
    GoRoute(
      path: '/employee',
      builder: (context, state) => EmployeePage(),
    ),
  ],
  redirect: (context, state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) return null;

    var allowedAnnounymousRoutes = ['/signup', '/login'];
    if (allowedAnnounymousRoutes.contains(state.matchedLocation)) return null;

    return '/login';
  },
);
