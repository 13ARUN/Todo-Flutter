import 'package:flutter/material.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/widgets/taskitem.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key, required this.tasklist});

  final List<TaskModel> tasklist;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ListView.builder(
        itemCount: tasklist.length,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.all(8),
          child: TaskItem(task: tasklist[index]),
        ),
      ),
    );
  }
}
