// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tasky/Provider/auth_proider.dart';
// import 'package:provider/provider.dart';
// import 'package:tasky/sign/login_page.dart';
// import 'package:tasky/sign/signup_page.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   var authProvider = AuthProvider();
//   await authProvider.loadPreviousUser();
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => authProvider),
//       ],
//       child: const MainApp(),
//     ),
//   );
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'Meditation App',
//       routerConfig: _router,
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: Color(0xFF8990FF),
//         scaffoldBackgroundColor: Color(0xFFE0E7FF),
//         appBarTheme: AppBarTheme(
//           backgroundColor: Color(0xFF8990FF),
//         ),
//         textTheme: TextTheme(
//           headlineLarge: TextStyle(
//             color: Color.fromARGB(255, 0, 0, 0),
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//           bodyLarge: TextStyle(
//             color: Color.fromARGB(255, 0, 0, 0),
//           ),
//         ),
//       ),
//     );
//   }
// }

// final _router = GoRouter(
//   initialLocation: '/login',
//   routes: [
//     GoRoute(
//       path: '/login',
//       builder: (context, state) => LoginPage(),
//     ),
//     GoRoute(
//       path: '/signup',
//       builder: (context, state) => SignupPage(),
//     ),
//   ],
// );
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky/Provider/auth_proider.dart';

import 'package:provider/provider.dart';
import 'package:tasky/Provider/employee_provider.dart';
import 'package:tasky/Provider/taskprovider.dart';
import 'package:tasky/pages/employeep.dart';
import 'package:tasky/pages/home_manager.dart';
import 'package:tasky/pages/managerp.dart';
import 'package:tasky/sign/login_page.dart';
import 'package:tasky/sign/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var authProvider = AuthProvider();
  await authProvider.loadPreviousUser();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
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
      title: 'Tasky',
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

final GoRouter _router = GoRouter(
  initialLocation: '/login',
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
      path: '/manager',
      builder: (context, state) => ManagerTabScreen(),
    ),
    GoRoute(
      path: '/employee',
      builder: (context, state) => EmployeeScreen(),
    ),
  ],
  redirect: (context, state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isLoggedIn = authProvider.user != null;
    final isGoingToLogin = state.matchedLocation == '/login';

    if (!isLoggedIn && !isGoingToLogin) return '/login';
    if (isLoggedIn && isGoingToLogin) {
      return authProvider.user!.role == 'manager' ? '/manager' : '/employee';
    }
    return null;
  },
);
