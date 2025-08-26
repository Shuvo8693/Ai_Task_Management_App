import 'package:ai_task_management_app/data/models/project_model.dart';
import 'package:ai_task_management_app/domain/repositories/project_repository.dart';
import 'package:get/get.dart';


class ProjectController extends GetxController {
  final ProjectRepository projectRepository;
  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  ProjectController({required this.projectRepository});

  @override
  void onInit() {
    super.onInit();
    loadProjects();
  }

  Future<void> loadProjects() async {
    try {
      isLoading.value = true;
      error.value = '';
      final projectList = await projectRepository.getProjects();
      projects.assignAll(projectList);
    } catch (e) {
      error.value = 'Failed to load projects: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProject(ProjectModel project) async {
    try {
      isLoading.value = true;
      error.value = '';
      await projectRepository.addProject(project);
      projects.add(project);
      Get.back();
      Get.snackbar('Success', 'Project added successfully');
    } catch (e) {
      error.value = 'Failed to add project: $e';
      Get.snackbar('Error', 'Failed to add project');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProject(ProjectModel project) async {
    try {
      isLoading.value = true;
      error.value = '';
      await projectRepository.updateProject(project);
      final index = projects.indexWhere((p) => p.id == project.id);
      if (index != -1) {
        projects[index] = project;
      }
      Get.back();
      Get.snackbar('Success', 'Project updated successfully');
    } catch (e) {
      error.value = 'Failed to update project: $e';
      Get.snackbar('Error', 'Failed to update project');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      isLoading.value = true;
      error.value = '';
      await projectRepository.deleteProject(id);
      projects.removeWhere((project) => project.id == id);
      Get.snackbar('Success', 'Project deleted successfully');
    } catch (e) {
      error.value = 'Failed to delete project: $e';
      Get.snackbar('Error', 'Failed to delete project');
    } finally {
      isLoading.value = false;
    }
  }
}