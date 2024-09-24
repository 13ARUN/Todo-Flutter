import 'package:flutter/material.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/widgets/taskitem.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.tasklist,
    required this.onDeleteTask,
    required this.onEditTask,
  });

  final List<TaskModel> tasklist;
  final void Function(TaskModel task) onDeleteTask; // Function to delete a task
  final void Function(TaskModel task) onEditTask;   // Function to edit a task

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ListView.builder(
        itemCount: tasklist.length,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.all(8),
          child: TaskItem(
            task: tasklist[index],
            onDelete: () => onDeleteTask(tasklist[index]), // Pass delete handler
            onEdit: (TaskModel editedTask) => onEditTask(editedTask),     // Pass edit handler
          ),
        ),
      ),
    );
  }
}
