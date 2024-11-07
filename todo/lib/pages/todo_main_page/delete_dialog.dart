part of 'todo_main_page.dart';

/// Shows a confirmation dialog to delete tasks.
///
/// This function presents a dialog asking the user to confirm their action
/// for deleting either all tasks or just the completed tasks. The dialog
/// is displayed using the [showDialog] method.
///
/// Parameters:
/// - [context]: The BuildContext for the dialog.
/// - [ref]: The WidgetRef to access the tasks provider.
/// - [action]: A string indicating whether to delete "all" tasks or
///   just the completed ones.
Future<void> confirmDelete(
    BuildContext context, WidgetRef ref, String action) async {
  final bool isDeleteAll = (action == "all");

  // Show a dialog to confirm deletion
  showDialog(
    context: context,
    builder: (ctx) => buildDeleteDialog(ctx, ref, isDeleteAll),
  );
}

/// Builds a dialog for confirming task deletion.
///
/// This widget creates an [AlertDialog] that prompts the user to confirm
/// the deletion of tasks. The title and content of the dialog change
/// based on whether the user is deleting all tasks or just completed ones.
///
/// Parameters:
/// - [context]: The BuildContext for the dialog.
/// - [ref]: The WidgetRef to access the tasks provider.
/// - [isDeleteAll]: A boolean indicating if all tasks are to be deleted.
Widget buildDeleteDialog(
    BuildContext context, WidgetRef ref, bool isDeleteAll) {
  return AlertDialog(
    title:
        Text(isDeleteAll ? "Confirm Delete All" : "Confirm Delete Completed"),
    content: Text(
      isDeleteAll
          ? "Are you sure you want to delete all tasks?"
          : "Are you sure you want to delete all completed tasks? This action cannot be undone.",
    ),
    actions: [
      TextButton(
        onPressed: () {
          // Close the dialog without performing any action
          Navigator.pop(context);
        },
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          // Delete the appropriate tasks based on user choice
          if (isDeleteAll) {
            ref.read(tasksProvider.notifier).deleteAllTasks();
          } else {
            ref.read(tasksProvider.notifier).deleteCompletedTasks();
          }
          // Close the dialog after deletion
          Navigator.pop(context);
        },
        child: const Text('Delete'),
      ),
    ],
  );
}
