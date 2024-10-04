import 'package:flutter/material.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/widgets/taskitem.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.tasklist,
    required this.onDeleteTask,
    required this.onEditTask,
    required this.onToggleCompleteTask,
  });

  final List<TaskModel> tasklist;
  final void Function(TaskModel task) onDeleteTask;
  final void Function(TaskModel task) onEditTask;
  final void Function(TaskModel task) onToggleCompleteTask;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: tasklist.length + 1,
        itemBuilder: (context, index) {
          if (index == tasklist.length) {
            return const SizedBox(height: 65);
          }
          return Container(
            margin: const EdgeInsets.all(8),
            child: TaskItem(
              task: tasklist[index],
              onDelete: () => onDeleteTask(tasklist[index]),
              onEdit: (TaskModel editedTask) => onEditTask(editedTask),
              onToggleComplete: () => onToggleCompleteTask(tasklist[index]),
            ),
          );
        },
      ),
    );
  }
}
