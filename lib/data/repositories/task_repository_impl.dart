// lib/data/repositories/task_repository_impl.dart
import 'package:ai_task_management_app/data/models/task_model.dart';
import 'package:ai_task_management_app/domain/repositories/task_repository.dart';
import 'package:sqflite/sqflite.dart';
import '../datasources/local/database_service.dart';
import '../datasources/remote/mock_api_service.dart';
import '../datasources/local/auth_local_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final DatabaseService databaseService;
  final MockApiService mockApiService;
  final AuthLocalDataSource authLocalDataSource;

  TaskRepositoryImpl({
    required this.databaseService,
    required this.mockApiService,
    required this.authLocalDataSource,
  });

  @override
  Future<String> addTask(TaskModel task) async {
    final db = await databaseService.database;
    await db.insert('tasks', task.toMap());

    // Sync with mock API
    try {
      await mockApiService.post('/tasks', task.toMap());
    } catch (e) {
      print('Failed to sync task with remote: $e');
    }

    return task.id;
  }

  @override
  Future<void> deleteTask(String id) async {
    final db = await databaseService.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);

    // Sync with mock API
    try {
      await mockApiService.delete('/tasks/$id');
    } catch (e) {
      print('Failed to sync task deletion with remote: $e');
    }
  }

  @override
  Future<TaskModel> getTask(String id) async {
    final db = await databaseService.database;
    final maps = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return TaskModel.fromMap(maps.first);
    }
    throw Exception('Task not found');
  }

  @override
  Future<List<TaskModel>> getTasks({String? projectId, bool? completed}) async {
    final db = await databaseService.database;
    String where = '1 = 1';
    List<dynamic> whereArgs = [];

    if (projectId != null) {
      where += ' AND projectId = ?';
      whereArgs.add(projectId);
    }

    if (completed != null) {
      where += ' AND isCompleted = ?';
      whereArgs.add(completed ? 1 : 0);
    }

    final maps = await db.query(
      'tasks',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'dueDate ASC, priority DESC',
    );

    return maps.map((map) => TaskModel.fromMap(map)).toList();
  }

  @override
  Future<void> markAsCompleted(String id, bool completed) async {
    final db = await databaseService.database;
    await db.update(
      'tasks',
      {'isCompleted': completed ? 1 : 0, 'updatedAt': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );

    // Sync with mock API
    try {
      await mockApiService.put('/tasks/$id', {'isCompleted': completed});
    } catch (e) {
      print('Failed to sync task completion with remote: $e');
    }
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final db = await databaseService.database;
    await db.update(
      'tasks',
      task.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );

    // Sync with mock API
    try {
      await mockApiService.put('/tasks/${task.id}', task.toMap());
    } catch (e) {
      print('Failed to sync task update with remote: $e');
    }
  }

  @override
  Future<List<TaskModel>> getOverdueTasks() async {
    final db = await databaseService.database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final maps = await db.query(
      'tasks',
      where: 'dueDate < ? AND isCompleted = 0',
      whereArgs: [now],
      orderBy: 'dueDate ASC',
    );
    return maps.map((map) => TaskModel.fromMap(map)).toList();
  }

  @override
  Future<void> syncTasksWithRemote() async {
    try {
      // Check if user is authenticated
      final isLoggedIn = await authLocalDataSource.isLoggedIn();
      if (!isLoggedIn) return;

      // Get tasks from remote
      final response = await mockApiService.get('/tasks');
      if (response['status'] == 'success') {
        final remoteTasks = response['data'] as List<dynamic>;

        // Merge with local tasks
        final db = await databaseService.database;
        await db.transaction((txn) async {
          for (final taskData in remoteTasks) {
            // Upsert logic here - update if exists, insert if not
            final task = TaskModel.fromMap(Map<String, dynamic>.from(taskData));
            await txn.insert(
              'tasks',
              task.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        });
      }
    } catch (e) {
      // Handle error but don't throw - offline first approach
      print('Task sync failed: $e');
    }
  }
}