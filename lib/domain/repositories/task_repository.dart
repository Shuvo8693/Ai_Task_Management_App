// lib/domain/repositories/task_repository.dart
import 'package:ai_task_management_app/data/models/task_model.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> getTasks({String? projectId, bool? completed});
  Future<TaskModel> getTask(String id);
  Future<String> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<void> markAsCompleted(String id, bool completed);
  Future<List<TaskModel>> getOverdueTasks();
  Future<void> syncTasksWithRemote();
}