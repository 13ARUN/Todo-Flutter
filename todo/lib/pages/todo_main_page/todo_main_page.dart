import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/pages/settings_page/settings.dart';
import 'package:todo/pages/task_input_page/task_input.dart';
import 'package:todo/providers/tasks_provider.dart';
import 'package:todo/theme/theme_data.dart';
import 'package:todo/utils/logger/logger.dart';
import 'package:todo/utils/snackbar/snackbar_service.dart';
import 'package:todo/widgets/task_list.dart';

part 'app_bar.dart';
part 'delete_dialog.dart';
part 'task_view.dart';

/// The main page of the Todo application that displays tasks in a tabbed interface.
///
/// This page includes tabs for all tasks, in-progress tasks, and completed tasks.
/// The UI updates in response to changes in the task list, and a shimmer effect is shown
/// while tasks are loading.
class TodoMainPage extends ConsumerWidget {
  const TodoMainPage({super.key});

  static final logger = getLogger('TodoMainPage');
  static final GlobalKey addTaskKey = GlobalKey();
  static final GlobalKey allTasksKey = GlobalKey();
  static final GlobalKey refreshTasksKey = GlobalKey();
  static final GlobalKey popupMenuKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.t("Build Method Executing");
    final taskNotifier = ref.watch(tasksProvider.notifier);
    final tasks = ref.watch(tasksProvider);

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 3, // Number of tabs for all, in-progress, and completed tasks
      child: Scaffold(
        appBar: buildAppBar(
            context, ref, refreshTasksKey, popupMenuKey), // Builds the app bar
        floatingActionButton: Showcase(
          key: addTaskKey,
          title: 'Add Task',
          description: 'Tap here to add a new task.',
          targetBorderRadius: BorderRadius.circular(15),
          child: buildFloatingButton(context, ref),
        ), // Floating button to add new tasks
        body: SafeArea(
          child: taskNotifier.isLoading
              ? _buildShimmerEffect(
                  isDarkMode) // Shows shimmer effect while loading tasks
              : _buildTaskTabs(tasks), // Displays the task tabs
        ),
      ),
    );
  }

  /// Builds the tabs for displaying different categories of tasks.
  ///
  /// Returns a [TabBarView] containing the views for all tasks, in-progress tasks,
  /// and completed tasks.
  ///
  /// [tasks] is the list of all tasks.
  Widget _buildTaskTabs(List<TaskModel> tasks) {
    logger.t("Executing _buildTaskTabs method");
    return TabBarView(
      physics: const BouncingScrollPhysics(),
      children: [
        Showcase(
          key: allTasksKey,
          title: 'All Tasks',
          description: 'View all your tasks here.',
          child: tasks.isNotEmpty ? tasksView(tasks) : noTasksView(tasks),
        ),
        getInProgressTasks(tasks).isNotEmpty
            ? tasksView(getInProgressTasks(tasks)) // View for in-progress tasks
            : noTasksView(tasks),
        getCompletedTasks(tasks).isNotEmpty
            ? tasksView(getCompletedTasks(tasks)) // View for completed tasks
            : noTasksView(tasks),
      ],
    );
  }

  /// Builds a shimmer effect for loading indication.
  ///
  /// Returns a [TabBarView] with shimmer effects to indicate loading state for tasks.
  ///
  /// [isDarkMode] indicates whether the current theme is dark.
  Widget _buildShimmerEffect(bool isDarkMode) {
    logger.t("Executing _buildShimmerEffect method");
    return TabBarView(
      physics: const BouncingScrollPhysics(),
      children: [
        _buildShimmerList(isDarkMode), // Shimmer list for the first tab
        _buildShimmerList(isDarkMode), // Shimmer list for the second tab
        _buildShimmerList(isDarkMode), // Shimmer list for the third tab
      ],
    );
  }

  /// Builds a list with a shimmer effect for loading tasks.
  ///
  /// Returns a [ListView] with shimmer effects that simulate task items being loaded.
  ///
  /// [isDarkMode] indicates whether the current theme is dark.
  Widget _buildShimmerList(bool isDarkMode) {
    logger.t("Executing _buildShimmerList method");
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: 7, // Number of shimmer items
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
                        width: 300, // Width of shimmer effect for title
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Container(
                        height: 12.0,
                        width: 200, // Width of shimmer effect for subtitle
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 10),
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

  /// Filters the list of tasks to get only the in-progress tasks.
  ///
  /// Returns a list of tasks that are not completed.
  List<TaskModel> getInProgressTasks(List<TaskModel> tasks) {
    return tasks.where((task) => !task.isCompleted).toList();
  }

  /// Filters the list of tasks to get only the completed tasks.
  ///
  /// Returns a list of tasks that are marked as completed.
  List<TaskModel> getCompletedTasks(List<TaskModel> tasks) {
    return tasks.where((task) => task.isCompleted).toList();
  }

  /// Builds the floating action button for adding new tasks.
  ///
  /// Returns a [FloatingActionButton] that navigates to the task input page
  /// when pressed. If a new task is created, it adds it to the task provider.
  FloatingActionButton buildFloatingButton(
      BuildContext context, WidgetRef ref) {
    logger.t("Executing buildFloatingButton method");
    return FloatingActionButton(
      onPressed: () async {
        logger.i("Add task floating action button clicked");
        final newTask = await Navigator.push<TaskModel>(
          context,
          MaterialPageRoute(
            builder: (context) => const TaskInput(
                action: 'add'), // Navigates to the task input page
          ),
        );

        if (newTask != null) {
          ref
              .read(tasksProvider.notifier)
              .addTask(newTask); // Adds the new task to the provider
        }
      },
      child: const Icon(Icons.add), // Icon for the floating button
    );
  }
}
