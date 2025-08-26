// lib/presentation/ai_assistant/views/ai_assistant_screen.dart
import 'package:ai_task_management_app/presentation/ai_assistant/ai_assistant_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_task_management_app/presentation/projects/controllers/project_controller.dart';

class AIAssistantScreen extends StatelessWidget {
  final AIAssistantController aiController = Get.find();
  final ProjectController projectController = Get.find();
  final TextEditingController promptController = TextEditingController();

  AIAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: promptController,
              decoration: InputDecoration(
                labelText: 'Tell me what tasks you need...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (promptController.text.isNotEmpty) {
                      aiController.prompt.value = promptController.text;
                      aiController.generateTasks();
                    }
                  },
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Obx(() => aiController.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () {
                if (promptController.text.isNotEmpty) {
                  aiController.prompt.value = promptController.text;
                  aiController.generateTasks();
                }
              },
              child: const Text('Generate Tasks'),
            )),
            const SizedBox(height: 20),
            Obx(() {
              if (aiController.generatedTasks.isEmpty) {
                return const Expanded(
                  child: Center(
                    child: Text(
                      'Describe the tasks you need help with, and I\'ll generate them for you!\n\nExamples:\n- "Plan my week with work tasks"\n- "Create a shopping list"\n- "Tasks for my fitness routine"',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }

              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Generated Tasks:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: aiController.generatedTasks.length,
                        itemBuilder: (context, index) {
                          final task = aiController.generatedTasks[index];
                          return ListTile(
                            leading: const Icon(Icons.lightbulb_outline),
                            title: Text(task),
                            trailing: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                _showImportDialog(task);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _showImportAllDialog();
                        },
                        child: const Text('Import All Tasks'),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showImportDialog(String taskTitle) {
    if (projectController.projects.isEmpty) {
      Get.snackbar('Error', 'Please create a project first');
      return;
    }

    String? selectedProjectId;

    Get.dialog(
      AlertDialog(
        title: const Text('Import Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Task: $taskTitle'),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Project',
                border: OutlineInputBorder(),
              ),
              items: projectController.projects
                  .map((project) => DropdownMenuItem(
                value: project.id,
                child: Text(project.name),
              ))
                  .toList(),
              onChanged: (value) {
                selectedProjectId = value;
              },
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
              if (selectedProjectId != null) {
                aiController.importTask(taskTitle, selectedProjectId!);
                Get.back();
              } else {
                Get.snackbar('Error', 'Please select a project');
              }
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  void _showImportAllDialog() {
    if (projectController.projects.isEmpty) {
      Get.snackbar('Error', 'Please create a project first');
      return;
    }

    String? selectedProjectId;

    Get.dialog(
      AlertDialog(
        title: const Text('Import All Tasks'),
        content: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Select Project',
            border: OutlineInputBorder(),
          ),
          items: projectController.projects
              .map((project) => DropdownMenuItem(
            value: project.id,
            child: Text(project.name),
          ))
              .toList(),
          onChanged: (value) {
            selectedProjectId = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedProjectId != null) {
                aiController.importAllTasks(selectedProjectId!);
                Get.back();
              } else {
                Get.snackbar('Error', 'Please select a project');
              }
            },
            child: const Text('Import All'),
          ),
        ],
      ),
    );
  }
}