import 'package:flutter/material.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/pages/todo_main_page/taskview/task_item.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.tasklist,
  });

  final List<TaskModel> tasklist;

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
            ),
          );
        },
      ),
    );
  }
}
