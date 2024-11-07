part of 'task_input.dart';

/// Builds a TextFormField for entering the task title.
///
/// [controller] controls the text being edited.
/// [action] specifies whether the task is being added or edited.
/// [task] is the task model for the current task (if editing).
/// [existingTasks] is the list of current tasks to check for duplicates.
Widget buildTitleField(TextEditingController controller, String action,
    TaskModel? task, List<TaskModel> existingTasks) {
  return TextFormField(
    autofocus: true, // Automatically focus on this field when the screen loads.
    controller: controller, // Text editing controller for this field.
    maxLength: 30, // Maximum length of the title.
    decoration: const InputDecoration(
      labelText: 'Title', // Label displayed above the field.
      hintText: 'Enter Task Title', // Placeholder text when the field is empty.
      suffixIcon:
          Icon(Icons.task_outlined), // Icon displayed at the end of the field.
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Enter a task title"; // Validation message if the title is empty.
      }

      if (value.trim().isEmpty) {
        controller.text =
            ''; // Clear the controller text if only spaces are entered.
        return "Task cannot contain only spaces"; // Validation message for spaces only.
      }

      // Check for existing titles (case-insensitive).
      if (existingTasks.any((t) =>
          t.title.toLowerCase() == value.trim().toLowerCase() &&
          (action == 'add' || (action == 'edit' && t.id != task?.id)))) {
        return 'Task title already exists'; // Validation message if title is a duplicate.
      }

      return null; // Return null if the input is valid.
    },
  );
}

/// Builds a TextFormField for entering the task description.
///
/// [controller] controls the text being edited.
Widget buildDescriptionField(TextEditingController controller) {
  return TextFormField(
    controller: controller, // Text editing controller for this field.
    minLines: 1, // Minimum number of lines to display.
    maxLines: 3, // Maximum number of lines to display.
    maxLength: 120, // Maximum length of the description.
    keyboardType: TextInputType.multiline, // Allows multiline input.
    decoration: const InputDecoration(
      labelText: 'Description', // Label displayed above the field.
      hintText:
          'Enter Task Description', // Placeholder text when the field is empty.
      suffixIcon: Icon(Icons
          .description_outlined), // Icon displayed at the end of the field.
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Enter a task description"; // Validation message if the description is empty.
      }

      if (value.trim().isEmpty) {
        controller.text =
            ''; // Clear the controller text if only spaces are entered.
        return "Task description cannot contain only spaces"; // Validation message for spaces only.
      }
      return null; // Return null if the input is valid.
    },
  );
}
