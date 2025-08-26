import 'package:ai_task_management_app/data/models/project_model.dart';
import 'package:ai_task_management_app/presentation/projects/controllers/project_controller.dart';
import 'package:ai_task_management_app/presentation/tasks/views/tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProjectsScreen extends StatelessWidget {
  final ProjectController projectController = Get.find();

  ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: Obx(() {
        if (projectController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: projectController.projects.length,
          itemBuilder: (context, index) {
            final project = projectController.projects[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(project.color),
                child: Text(
                  project.name[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(project.name),
              subtitle: project.description != null
                  ? Text(project.description!)
                  : null,
              onTap: () {
                Get.to(() => TasksScreen(), arguments: project.id);
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _showDeleteDialog(project);
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProjectDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddProjectDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Add New Project'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Project Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final project = ProjectModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  description: descriptionController.text.isNotEmpty
                      ? descriptionController.text
                      : null,
                  color: Colors.blue.value,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                projectController.addProject(project);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(ProjectModel project) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Project'),
        content: Text('Are you sure you want to delete "${project.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              projectController.deleteProject(project.id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}