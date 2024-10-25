import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart'; // Import the shimmer package
import 'package:todo/models/task_model.dart';
import 'package:todo/pages/settings_page/settings.dart';
import 'package:todo/pages/task_input_page/task_input.dart';
import 'package:todo/pages/todo_main_page/taskview/task_list.dart';
import 'package:todo/services/providers/tasks_provider.dart';

part 'app_bar.dart';
part 'delete_dialog.dart';
part 'taskview/task_view.dart';

class TodoMainPage extends ConsumerWidget {
  const TodoMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskNotifier = ref.watch(tasksProvider.notifier);
    final tasks = ref.watch(tasksProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: buildAppBar(context, ref),
        floatingActionButton: buildFloatingButton(context, ref),
        body: SafeArea(
          child: taskNotifier.isLoading ? _buildShimmerEffect() : _buildTaskTabs(tasks),
        ),
      ),
    );
  }

  Widget _buildTaskTabs(List<TaskModel> tasks) {
    return TabBarView(
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
    );
  }

  Widget _buildShimmerEffect() {
    return TabBarView(
      physics: const BouncingScrollPhysics(),
      children: [
        _buildShimmerList(),
        _buildShimmerList(),
        _buildShimmerList(),
      ],
    );
  }

  Widget _buildShimmerList() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[600]!,
              highlightColor: Colors.grey[400]!,
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Container(
                    height: 20.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 5.0),
                  child: Container(
                    height: 15.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                tileColor: Colors.grey[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<TaskModel> getInProgressTasks(List<TaskModel> tasks) {
    return tasks.where((task) => !task.isCompleted).toList();
  }

  List<TaskModel> getCompletedTasks(List<TaskModel> tasks) {
    return tasks.where((task) => task.isCompleted).toList();
  }

  FloatingActionButton buildFloatingButton(
      BuildContext context, WidgetRef ref) {
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
