import 'package:flutter/material.dart';
import 'package:todo/models/task_model.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Checkbox(value: false, onChanged: null),
      title: Text(task.title),
      subtitle: Text(task.description),
      trailing: const Icon(Icons.delete_rounded),
      tileColor: const Color.fromARGB(255, 233, 224, 248),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
