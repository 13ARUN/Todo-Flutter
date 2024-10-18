part of 'todo_main_page.dart';

Future<void> confirmDelete(
    BuildContext context, WidgetRef ref, String action) async {
  final bool isDeleteAll = (action == "all");

  showDialog(
    context: context,
    builder: (ctx) => buildDeleteDialog(ctx, ref, isDeleteAll),
  );
}

Widget buildDeleteDialog(
    BuildContext context, WidgetRef ref, bool isDeleteAll) {
  return AlertDialog(
    title: Text(isDeleteAll ? "Confirm Delete All" : "Confirm Delete Completed"),
    content: Text(isDeleteAll
        ? "Are you sure you want to delete all tasks?"
        : "Are you sure you want to delete all completed tasks? This action cannot be undone."),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          isDeleteAll
              ? ref.read(tasksProvider.notifier).deleteAllTasks()
              : ref.read(tasksProvider.notifier).deleteCompletedTasks();
          Navigator.pop(context);
        },
        child: const Text('Delete'),
      ),
    ],
  );
}
