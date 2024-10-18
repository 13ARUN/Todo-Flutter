import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/pages/settings_page/settings.dart';
import 'package:todo/pages/task_input/task_input.dart';
import 'package:todo/services/providers/tasks_provider.dart';
import 'package:todo/widgets/task_list.dart';

part 'app_bar.dart';
part 'delete_dialog.dart';
part 'task_view.dart';

class TodoMainPage extends ConsumerWidget {
  const TodoMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: buildAppBar(context, ref),
        floatingActionButton: buildFloatingButton(context, ref),
        body: SafeArea(
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: [
              tasks.isNotEmpty ? tasksView(tasks) : noTasksView(tasks),
              getInProgressTasks(tasks).isNotEmpty
                  ? tasksView(getInProgressTasks(tasks))
                  : noTasksView(tasks),
              getCompletedTasks(tasks).isNotEmpty
                  ? tasksView(getCompletedTasks(tasks))
                  : noTasksView(tasks),
            ],
          ),
        ),
      ),
    );
  }

  List<TaskModel> getInProgressTasks(List<TaskModel> tasks) {
    return tasks.where((task) => !task.isCompleted).toList();
  }

  List<TaskModel> getCompletedTasks(List<TaskModel> tasks) {
    return tasks.where((task) => task.isCompleted).toList();
  }

  FloatingActionButton buildFloatingButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () async {
        final newTask = await Navigator.push<TaskModel>(
          context,
          MaterialPageRoute(
            builder: (context) => const TaskInput(action: 'add'),
          ),
        );

        if (newTask != null) {
          ref.read(tasksProvider.notifier).addTask(newTask);
        }
      },
      child: const Icon(Icons.add),
    );
  }
}
