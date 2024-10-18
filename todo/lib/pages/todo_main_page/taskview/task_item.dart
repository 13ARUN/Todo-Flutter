import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/pages/task_input/task_input.dart';
import 'package:todo/theme/theme_data.dart';
import 'package:todo/services/providers/tasks_provider.dart';

class TaskItem extends ConsumerWidget {
  const TaskItem({
    super.key,
    required this.task,
  });

  final TaskModel task;

  Future<void> _showDeleteConfirmation(
      BuildContext context, WidgetRef ref) async {
    if (Platform.isIOS) {
      showCupertinoDialog<bool>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Delete Task'),
          content: Text(
              "Are you sure you want to delete the task '${task.title}' ?"),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
                ref.read(tasksProvider.notifier).deleteTask(task.id);
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    } else {
      showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete Task'),
          content: Text(
              "Are you sure you want to delete the task '${task.title}' ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ref.read(tasksProvider.notifier).deleteTask(task.id);
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return ListTile(
      onTap: task.isCompleted
          ? null
          : () async {
              final editedTask = await Navigator.push<TaskModel>(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskInput(
                    action: 'edit',
                    task: task,
                  ),
                ),
              );

              if (editedTask != null) {
                ref.read(tasksProvider.notifier).editTask(editedTask);
              }
            },
      title: Text(
        task.title,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      subtitle: Text(task.date),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: task.isCompleted,
            onChanged: (value) {
              if (value != null) {
                ref.read(tasksProvider.notifier).toggleTaskCompletion(task);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_rounded),
            onPressed: () => _showDeleteConfirmation(context, ref),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      tileColor: task.isCompleted
          ? isDarkMode
              ? kDarkColorScheme.surfaceContainerLow
              : kColorScheme.surfaceContainerHigh
          : isDarkMode
              ? kDarkColorScheme.onPrimaryFixedVariant
              : kColorScheme.primaryFixedDim,
    );
  }
}
