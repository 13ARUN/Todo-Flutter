part of 'todo_main_page.dart';

/// Builds the main [AppBar] for the Todo application.
///
/// This function creates an [AppBar] with a title, refresh button, and a
/// popup menu for additional options. It also includes a [TabBar] to
/// navigate between different task categories.
///
/// Parameters:
/// - [context]: The BuildContext for the app bar.
/// - [ref]: The WidgetRef to access the tasks provider.
AppBar buildAppBar(
  BuildContext context,
  WidgetRef ref,
  GlobalKey<State<StatefulWidget>> refreshTasksKey,
  GlobalKey<State<StatefulWidget>> popupMenuKey,
) {
  final width = MediaQuery.of(context).size.width;

  return AppBar(
    title: const Text('Task Manager'),
    titleSpacing: 25,
    actions: [
      // Button to refresh tasks from the API
      Showcase(
        key: refreshTasksKey,
        title: 'Refresh',
        description: 'Tap to refresh your task list.',
        child: IconButton(
            onPressed: () async {
              await ref.read(tasksProvider.notifier).loadTasksfromAPI();
              SnackbarService.displaySnackBar('Fetched the latest tasks.');
            },
            icon: const Icon(Icons.refresh_rounded)),
      ),
      Showcase(
        key: popupMenuKey,
        title: 'Menu',
        description: 'Use this to access more options.',
        child: _buildPopupMenu(context, ref),
      )
    ],
    bottom: TabBar(
      tabs: [
        Tab(
            icon: width < 600 ? const Icon(Icons.list) : null,
            text: 'All Tasks'),
        Tab(
            icon: width < 600 ? const Icon(Icons.watch_later_outlined) : null,
            text: 'In Progress'),
        Tab(
            icon: width < 600 ? const Icon(Icons.done_all) : null,
            text: 'Completed'),
      ],
    ),
  );
}

/// Builds a popup menu for additional app options.
///
/// This widget creates a [PopupMenuButton] that allows the user to access
/// settings and delete tasks. It displays options for deleting all tasks
/// or just completed tasks based on the current task list.
///
/// Parameters:
/// - [context]: The BuildContext for the popup menu.
/// - [ref]: The WidgetRef to access the tasks provider.
Widget _buildPopupMenu(BuildContext context, WidgetRef ref) {
  return PopupMenuButton(
    position: PopupMenuPosition.under,
    itemBuilder: (context) => <PopupMenuItem>[
      PopupMenuItem(
        child: ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Settings(),
              ),
            );
          },
        ),
      ),
      // Show option to delete all tasks if the task list is not empty
      if (ref.read(tasksProvider).isNotEmpty)
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete all'),
            onTap: () {
              Navigator.pop(context);
              confirmDelete(context, ref, 'all');
            },
          ),
        ),
      // Show option to delete completed tasks if there are any
      if (ref.read(tasksProvider).any((task) => task.isCompleted))
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.delete_sweep_rounded),
            title: const Text('Delete completed'),
            onTap: () {
              Navigator.pop(context);
              confirmDelete(context, ref, 'completed');
            },
          ),
        ),
    ],
  );
}
