part of 'todo_main_page.dart';

AppBar buildAppBar(BuildContext context, WidgetRef ref) {
  final width = MediaQuery.of(context).size.width;

  return AppBar(
    title: const Text('Task Manager'),
    titleSpacing: 25,
    actions: [
      IconButton(
          onPressed: () {
            ref.read(tasksProvider.notifier).loadTasksfromAPI();
            SnackbarService.displaySnackBar('Fetched the latest tasks');
          },
          icon: const Icon(Icons.refresh_rounded)),
      _buildPopupMenu(context, ref)
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
      // PopupMenuItem(
      //   child: ListTile(
      //     leading: const Icon(Icons.refresh),
      //     title: const Text('Refresh'),
      //     onTap: () {
      //       Navigator.pop(context);
      //       ref.read(tasksProvider.notifier).loadTasksfromAPI();
      //     },
      //   ),
      // ),
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
