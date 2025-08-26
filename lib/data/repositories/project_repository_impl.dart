

import 'package:ai_task_management_app/data/datasources/local/auth_local_data_source.dart';
import 'package:ai_task_management_app/data/datasources/local/database_service.dart';
import 'package:ai_task_management_app/data/datasources/remote/mock_api_service.dart';
import 'package:ai_task_management_app/data/models/project_model.dart';
import 'package:ai_task_management_app/domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final DatabaseService databaseService;
  final MockApiService mockApiService;
  final AuthLocalDataSource authLocalDataSource;

  ProjectRepositoryImpl({
    required this.databaseService,
    required this.mockApiService,
    required this.authLocalDataSource,
  });

  @override
  Future<String> addProject(ProjectModel project) async {
    final db = await databaseService.database;
    await db.insert('projects', project.toMap());

    // Sync with mock API
    try {
      await mockApiService.post('/projects', project.toMap());
    } catch (e) {
      print('Failed to sync project with remote: $e');
    }

    return project.id;
  }

  @override
  Future<void> deleteProject(String id) async {
    final db = await databaseService.database;
    await db.delete('projects', where: 'id = ?', whereArgs: [id]);

    // Sync with mock API
    try {
      await mockApiService.delete('/projects/$id');
    } catch (e) {
      print('Failed to sync project deletion with remote: $e');
    }
  }

  @override
  Future<ProjectModel> getProject(String id) async {
    final db = await databaseService.database;
    final maps = await db.query(
      'projects',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return ProjectModel.fromMap(maps.first);
    }
    throw Exception('Project not found');
  }

  @override
  Future<List<ProjectModel>> getProjects() async {
    final db = await databaseService.database;
    final maps = await db.query('projects', orderBy: 'name ASC');
    return maps.map((map) => ProjectModel.fromMap(map)).toList();
  }

  @override
  Future<void> updateProject(ProjectModel project) async {
    final db = await databaseService.database;
    await db.update(
      'projects',
      project.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [project.id],
    );

    // Sync with mock API
    try {
      await mockApiService.put('/projects/${project.id}', project.toMap());
    } catch (e) {
      print('Failed to sync project update with remote: $e');
    }
  }

  @override
  Future<void> syncProjectsWithRemote() async {
    try {
      // Check if user is authenticated
      final isLoggedIn = await authLocalDataSource.isLoggedIn();
      if (!isLoggedIn) return;

      // Get projects from remote
      final response = await mockApiService.get('/projects');
      if (response['status'] == 'success') {
        final remoteProjects = response['data'] as List<dynamic>;

        // Merge with local projects
        final db = await databaseService.database;
        await db.transaction((txn) async {
          for (final projectData in remoteProjects) {
            // Upsert logic here
          }
        });
      }
    } catch (e) {
      // Handle error but don't throw - offline first approach
      print('Project sync failed: $e');
    }
  }
}