import 'package:flutter/material.dart';
import 'package:tasky/Provider/employee_provider.dart';
import 'package:tasky/Provider/manager_provider.dart';
import 'package:provider/provider.dart';

void main() {
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => EmployeeProvider()),
      ChangeNotifierProvider(create: (_) => ManagerProvider()),
    ],
    child: MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
