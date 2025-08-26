// lib/presentation/ai_assistant/controllers/ai_assistant_controller.dart
import 'package:get/get.dart';
import 'package:ai_task_management_app/data/datasources/remote/ai_service.dart';
import 'package:ai_task_management_app/data/repositories/task_repository_impl.dart';
import 'package:ai_task_management_app/data/models/task_model.dart';
import 'package:uuid/uuid.dart';

class AIAssistantController extends GetxController {
  final AIService aiService;
  final TaskRepositoryImpl taskRepository;

  final RxList<String> generatedTasks = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString prompt = ''.obs;

  AIAssistantController({
    required this.aiService,
    required this.taskRepository,
  });

  Future<void> generateTasks() async {
    if (prompt.value.isEmpty) return;

    try {
      isLoading.value = true;
      error.value = '';
      final tasks = await aiService.generateTasksFromPrompt(prompt.value);
      generatedTasks.assignAll(tasks);
    } catch (e) {
      error.value = 'Failed to generate tasks: $e';
      Get.snackbar('Error', 'Failed to generate tasks');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> importTask(String taskTitle, String projectId) async {
    try {
      final task = TaskModel(
        id: const Uuid().v4(),
        projectId: projectId,
        title: taskTitle,
        description: 'AI-generated task',
        priority: TaskPriority.medium,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await taskRepository.addTask(task);
      Get.snackbar('Success', 'Task imported successfully');
    } catch (e) {
      error.value = 'Failed to import task: $e';
      Get.snackbar('Error', 'Failed to import task');
    }
  }

  Future<void> importAllTasks(String projectId) async {
    try {
      for (final taskTitle in generatedTasks) {
        final task = TaskModel(
          id: const Uuid().v4(),
          projectId: projectId,
          title: taskTitle,
          description: 'AI-generated task',
          priority: TaskPriority.medium,
          dueDate: DateTime.now().add(const Duration(days: 1)),
          isCompleted: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await taskRepository.addTask(task);
      }

      Get.snackbar('Success', 'All tasks imported successfully');
      generatedTasks.clear();
      prompt.value = '';
    } catch (e) {
      error.value = 'Failed to import tasks: $e';
      Get.snackbar('Error', 'Failed to import tasks');
    }
  }
}