

import 'package:ai_task_management_app/data/models/project_model.dart';

abstract class ProjectRepository {
  Future<List<ProjectModel>> getProjects();
  Future<ProjectModel> getProject(String id);
  Future<String> addProject(ProjectModel project);
  Future<void> updateProject(ProjectModel project);
  Future<void> deleteProject(String id);
  Future<void> syncProjectsWithRemote();
}