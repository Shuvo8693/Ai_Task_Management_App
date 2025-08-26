// lib/presentation/tasks/views/tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_task_management_app/data/models/task_model.dart';
import 'package:ai_task_management_app/presentation/tasks/controllers/task_controller.dart';


class TasksScreen extends StatelessWidget {
  final TaskController taskController = Get.find();
  final String? projectId;

  TasksScreen({super.key, this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: Obx(() {
        if (taskController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = projectId != null
            ? taskController.tasks.where((task) => task.projectId == projectId).toList()
            : taskController.tasks;

        if (tasks.isEmpty) {
          return const Center(
            child: Text('No tasks found. Create your first task!'),
          );
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ListTile(
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (value) {
                  taskController.toggleTaskCompletion(task.id, value ?? false);
                },
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (task.description != null) Text(task.description!),
                  if (task.dueDate != null)
                    Text('Due: ${task.dueDate!.toString().split(' ')[0]}'),
                ],
              ),
              trailing: Icon(
                task.priority == TaskPriority.high
                    ? Icons.flag
                    : task.priority == TaskPriority.medium
                    ? Icons.flag_outlined
                    : Icons.outlined_flag,
                color: task.priority == TaskPriority.high
                    ? Colors.red
                    : task.priority == TaskPriority.medium
                    ? Colors.orange
                    : Colors.green,
              ),
              onTap: () {
               // Get.to(() => TaskFormScreen(task: task));
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         // Get.to(() => TaskFormScreen(projectId: projectId));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}