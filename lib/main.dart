// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ai_task_management_app/core/utils/dependencies.dart';
import 'package:ai_task_management_app/presentation/auth/views/login_screen.dart';
import 'package:ai_task_management_app/presentation/auth/views/register_screen.dart';
import 'package:ai_task_management_app/presentation/dashboard/views/dashboard_screen.dart';
import 'package:ai_task_management_app/data/datasources/local/auth_local_data_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  DependenciesBinding().dependencies();

  runApp(const TaskManagementApp());
}

class TaskManagementApp extends StatelessWidget {
  const TaskManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AI Task Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: FutureBuilder(
        future: Get.find<AuthLocalDataSource>().getAuthData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final authData = snapshot.data ?? {};
          final isLoggedIn = authData['isLoggedIn'] == true;

          return isLoggedIn ? DashboardScreen() : const LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => DashboardScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}