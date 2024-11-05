import 'package:flutter/material.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/utils/logger/logger.dart';
import 'package:todo/widgets/task_item.dart';

/// A widget that displays a list of tasks.
class TaskList extends StatelessWidget {
  /// Creates a [TaskList] widget.
  ///
  /// The [tasklist] parameter must not be null and must contain the list of tasks to display.
  const TaskList({
    super.key,
    required this.tasklist,
  });

  /// Logger for tracking actions in this class.
  static final logger = getLogger('TaskList');

  /// List of tasks to be displayed in the task list.
  final List<TaskModel> tasklist;

  @override
  Widget build(BuildContext context) {
    // Log when the build method is called.
    logger.t("Build Method Executing");

    return Padding(
      padding: const EdgeInsets.all(10), // Padding around the list.
      child: ListView.builder(
        physics:
            const BouncingScrollPhysics(), // Enable bouncing scroll effect.
        itemCount: tasklist.length + 1, // +1 for the additional empty space.
        itemBuilder: (context, index) {
          // Check if the current index is for the extra space at the bottom.
          if (index == tasklist.length) {
            return const SizedBox(height: 65); // Space at the bottom.
          }
          // Return a container with a task item.
          return Container(
            margin: const EdgeInsets.all(8), // Margin around each task item.
            child: TaskItem(
              task: tasklist[index], // Pass the task to the TaskItem widget.
            ),
          );
        },
      ),
    );
  }
}
