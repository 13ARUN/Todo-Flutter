part of 'task_input.dart';

Widget buildTitleField(TextEditingController controller) {
  return TextFormField(
    autofocus: true,
    controller: controller,
    maxLength: 30,
    decoration: const InputDecoration(
      labelText: 'Title',
      hintText: 'Enter Task Title',
      suffixIcon: Icon(Icons.task_outlined),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Enter a task title";
      }
      if (value.trim().isEmpty) {
        return "Task cannot contain only spaces";
      }
      return null;
    },
  );
}

Widget buildDescriptionField(TextEditingController controller) {
  return TextFormField(
    controller: controller,
    minLines: 1,
    maxLines: 3,
    maxLength: 120,
    keyboardType: TextInputType.multiline,
    decoration: const InputDecoration(
      labelText: 'Description',
      hintText: 'Enter Task Description',
      suffixIcon: Icon(Icons.description_outlined),
    ),
  );
}

Widget buildDueDateField(
    TextEditingController controller, Future<void> Function() selectDate) {
  return TextFormField(
    controller: controller,
    readOnly: true,
    decoration: const InputDecoration(
      label: Text('Due Date'),
      hintText: 'Enter Task Due Date',
      suffixIcon: Icon(Icons.calendar_month),
    ),
    onTap: selectDate,
  );
}
