// lib/core/utils/dependencies.dart
import 'package:ai_task_management_app/data/datasources/remote/mock_api_service.dart';
import 'package:ai_task_management_app/data/repositories/project_repository_impl.dart';
import 'package:ai_task_management_app/domain/repositories/project_repository.dart';
import 'package:ai_task_management_app/presentation/ai_assistant/ai_assistant_controller.dart';
import 'package:ai_task_management_app/presentation/auth/controllers/auth_controller.dart';
import 'package:ai_task_management_app/presentation/projects/controllers/project_controller.dart';
import 'package:get/get.dart';
import 'package:ai_task_management_app/data/datasources/local/auth_local_data_source.dart';
import 'package:ai_task_management_app/data/datasources/local/database_service.dart';
import 'package:ai_task_management_app/data/datasources/remote/ai_service.dart';

import 'package:ai_task_management_app/data/repositories/task_repository_impl.dart';


import 'package:ai_task_management_app/presentation/tasks/controllers/task_controller.dart';

class DependenciesBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut(() => DatabaseService(), fenix: true);
    Get.lazyPut(() => AuthLocalDataSource(), fenix: true);
    Get.lazyPut(() => AIService(), fenix: true);
    Get.lazyPut(() => MockApiService(), fenix: true);

    // Repositories
    Get.put( TaskRepositoryImpl(
      databaseService: Get.find(),
      mockApiService: Get.find(),
      authLocalDataSource: Get.find(),
    ));

    Get.lazyPut<ProjectRepository>(() => ProjectRepositoryImpl(
      databaseService: Get.find(),
      mockApiService: Get.find(),
      authLocalDataSource: Get.find(),
    ), fenix: true);

    // Controllers
    Get.lazyPut(() => AuthenticationCont(
      authLocalDataSource: Get.find(),
    ), fenix: true);

    Get.lazyPut(() => TaskController(
      taskRepository: Get.find(),
    ), fenix: true);

    Get.lazyPut(() => ProjectController(
      projectRepository: Get.find(),
    ), fenix: true);

    Get.lazyPut(() => AIAssistantController(
      aiService: Get.find(),
      taskRepository: Get.find(),
    ), fenix: true);
  }
}