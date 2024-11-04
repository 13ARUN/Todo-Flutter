import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart'; // Import the shimmer package
import 'package:todo/models/task_model.dart';
import 'package:todo/pages/settings_page/settings.dart';
import 'package:todo/pages/task_input_page/task_input.dart';
import 'package:todo/widgets/task_list.dart';
import 'package:todo/providers/tasks_provider.dart';
import 'package:todo/theme/theme_data.dart';
import 'package:todo/utils/logger/logger.dart';
import 'package:todo/utils/snackbar/snackbar_service.dart';

part 'app_bar.dart';
part 'delete_dialog.dart';
part 'task_view.dart';

class TodoMainPage extends ConsumerWidget {
  const TodoMainPage({super.key});

  static final logger = getLogger('TodoMainPage');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.t("Build Method Executing");
    final taskNotifier = ref.watch(tasksProvider.notifier);
    final tasks = ref.watch(tasksProvider);

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: buildAppBar(context, ref),
        floatingActionButton: buildFloatingButton(context, ref),
        body: SafeArea(
          child: taskNotifier.isLoading
              ? _buildShimmerEffect(isDarkMode)
              : _buildTaskTabs(tasks),
        ),
      ),
    );
  }

  Widget _buildTaskTabs(List<TaskModel> tasks) {
    logger.t("Executing _buildTaskTabs method");
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

  Widget _buildShimmerEffect(bool isDarkMode) {
    logger.t("Executing _buildShimmerEffect method");
    return TabBarView(
      physics: const BouncingScrollPhysics(),
      children: [
        _buildShimmerList(isDarkMode),
        _buildShimmerList(isDarkMode),
        _buildShimmerList(isDarkMode),
      ],
    );
  }

  Widget _buildShimmerList(bool isDarkMode) {
    logger.t("Executing _buildShimmerList method");
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8),
            child: Shimmer.fromColors(
              baseColor: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
              highlightColor:
                  isDarkMode ? Colors.grey[500]! : Colors.grey[300]!,
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Row(
                    children: [
                      Container(
                        height: 15.0,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Container(
                        height: 12.0,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                tileColor: isDarkMode
                    ? Colors.grey[900]
                    : lightColorScheme.primaryContainer,
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
        logger.t("Executing buildFloatingButton method");
    return FloatingActionButton(
      onPressed: () async {
        logger.i("Add task floating action button clicked");
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
