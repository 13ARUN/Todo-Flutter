part of 'task_input.dart';

/// Builds a row of buttons for submitting or canceling the task input form.
///
/// [context] provides the BuildContext for navigation.
/// [formKey] is the global key for the form state, used for validation.
/// [submitTaskData] is the callback function that submits the task data.
/// [action] determines whether the button shows "Add" or "Update".
Widget buildFormButtons(BuildContext context, GlobalKey<FormState> formKey,
    VoidCallback submitTaskData, String action) {
  return Row(
    children: [
      Expanded(
        child: FilledButton(
          onPressed: () {
            Navigator.pop(
                context); // Closes the current screen and returns to the previous one.
          },
          child: const Text('Cancel'), // Button label for cancel action.
        ),
      ),
      const SizedBox(width: 25), // Spacing between the buttons.
      Expanded(
        child: FilledButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              // Validates the form input.
              submitTaskData(); // Calls the submit function if validation passes.
            }
          },
          child: Text(action == 'add'
              ? 'Add'
              : 'Update'), // Dynamic button label based on the action.
        ),
      ),
    ],
  );
}
