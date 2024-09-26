import 'package:flutter/material.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/pages/taskinput_page.dart';
import 'package:todo/theme/themedata.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onEdit,
    required this.onToggleComplete,
  });

  final TaskModel task;
  final void Function() onDelete;
  final void Function(TaskModel editedTask) onEdit;
  final void Function() onToggleComplete;

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task'),
        content:
            Text("Are you sure you want to delete the task?  '${task.title}'"),
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
    Brightness brightness = MediaQuery.of(context).platformBrightness;

    return ListTile(
      // onTap: () {
      //   showDialog(
      //     context: context,
      //     builder: (context) {
      //       return Dialog(
      //         child: SizedBox(
      //           height: 200,
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Text(task.title),
      //               Text(task.description),
      //               Text(task.date),
      //             ],
      //           ),
      //         ),
      //       );
      //     },
      //   );
      // },
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (value) {
          if (value != null) {
            onToggleComplete();
          }
        },
      ),
      title: Text(
        task.title,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      subtitle: Text('Due: ${task.date}'),
      // subtitle: task.isCompleted ? null : Text('Due: ${task.date}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!task.isCompleted)
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
            onPressed: () =>
                _showDeleteConfirmation(context), // Show confirmation dialog
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      tileColor: task.isCompleted
          ? brightness == Brightness.dark
              ? kColorScheme.onSurface
              : kColorScheme.surfaceContainerHighest
          : brightness == Brightness.dark
              ? kColorScheme.onPrimaryFixedVariant
              : kColorScheme.primaryFixedDim,
    );
  }
}
