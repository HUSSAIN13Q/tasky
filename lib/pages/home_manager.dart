import 'package:flutter/material.dart';
import 'package:tasky/pages/managerp.dart';
import 'package:tasky/pages/task_manager.dart';

class ManagerTabScreen extends StatelessWidget {
  const ManagerTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Manager Dashboard"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Assign Tasks"),
              Tab(text: "Review Tasks"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ManagerScreen(),
            TaskReviewScreen(),
          ],
        ),
      ),
    );
  }
}
