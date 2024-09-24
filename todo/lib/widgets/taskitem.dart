import 'package:flutter/material.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/pages/taskinput_page.dart'; // Import your TaskInput page

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onEdit,
    required this.onToggleComplete,  // Add a callback for toggling completion
  });

  final TaskModel task;
  final void Function() onDelete; // Callback for delete action
  final void Function(TaskModel editedTask) onEdit; // Function to call when task is edited
  final void Function(bool isCompleted) onToggleComplete; // New callback for completion toggle

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false), // Cancel deletion
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true), // Confirm deletion
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onDelete(); // Proceed with deletion if user confirmed
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.isCompleted, // Bind checkbox value to task's completion status
        onChanged: (value) {
          if (value != null) {
            onToggleComplete(value); // Call the function to toggle task completion status
          }
        },
      ),
      title: Text(
        task.title,
      ),
      subtitle: Text(task.date),
      trailing: Row(
        mainAxisSize: MainAxisSize.min, // Ensure buttons stay compact
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final editedTask = await Navigator.push<TaskModel>(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskInput(
                    action: 'edit',
                    task: task, // Pass the task to be edited
                  ),
                ),
              );

              if (editedTask != null) {
                onEdit(editedTask); // Update the task after editing
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_rounded),
            onPressed: () => _showDeleteConfirmation(context), // Show confirmation dialog
          ),
        ],
      ),
      tileColor: const Color.fromARGB(255, 233, 224, 248),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
