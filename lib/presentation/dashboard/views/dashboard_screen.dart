
import 'package:ai_task_management_app/presentation/tasks/views/tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ai_assistant/views/ai_assistant_screen.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../projects/views/projects_screen.dart';




class DashboardScreen extends StatelessWidget {
  final AuthenticationCont  authController = Get.find<AuthenticationCont>();

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authController.logout();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to ai_task_management_app AI!'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assistant),
            label: 'AI Assistant',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
               Get.to(() => TasksScreen());
              break;
            case 1:
               Get.to(() => ProjectsScreen());
              break;
            case 2:
               Get.to(() => AIAssistantScreen());
              break;
          }
        },
      ),
    );
  }
}