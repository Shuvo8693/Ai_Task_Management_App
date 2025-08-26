// lib/presentation/tasks/controllers/task_controller.dart
import 'package:ai_task_management_app/data/models/task_model.dart';
import 'package:get/get.dart';
import 'package:ai_task_management_app/data/repositories/task_repository_impl.dart';

class TaskController extends GetxController {
  final TaskRepositoryImpl taskRepository;
  final RxList<TaskModel> tasks = <TaskModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  TaskController({required this.taskRepository});

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> loadTasks({String? projectId}) async {
    try {
      isLoading.value = true;
      error.value = '';
      final taskList = await taskRepository.getTasks(projectId: projectId);
      tasks.assignAll(taskList);
    } catch (e) {
      error.value = 'Failed to load tasks: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      isLoading.value = true;
      error.value = '';
      await taskRepository.addTask(task);
      tasks.add(task);
      Get.back();
      Get.snackbar('Success', 'Task added successfully');
    } catch (e) {
      error.value = 'Failed to add task: $e';
      Get.snackbar('Error', 'Failed to add task');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      isLoading.value = true;
      error.value = '';
      await taskRepository.updateTask(task);
      final index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        tasks[index] = task;
      }
      Get.back();
      Get.snackbar('Success', 'Task updated successfully');
    } catch (e) {
      error.value = 'Failed to update task: $e';
      Get.snackbar('Error', 'Failed to update task');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      isLoading.value = true;
      error.value = '';
      await taskRepository.deleteTask(id);
      tasks.removeWhere((task) => task.id == id);
      Get.snackbar('Success', 'Task deleted successfully');
    } catch (e) {
      error.value = 'Failed to delete task: $e';
      Get.snackbar('Error', 'Failed to delete task');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleTaskCompletion(String id, bool completed) async {
    try {
      await taskRepository.markAsCompleted(id, completed);
      final index = tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        tasks[index] = tasks[index].copyWith(isCompleted: completed);
      }
    } catch (e) {
      error.value = 'Failed to update task: $e';
      Get.snackbar('Error', 'Failed to update task status');
    }
  }
}