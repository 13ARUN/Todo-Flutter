part of 'task_input.dart';

Future<void> _selectDate(
    BuildContext context, TextEditingController dueDateController) async {
  DateTime now = DateTime.now();
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(now.year + 1, now.month, now.day),
  );

  if (pickedDate != null) {
    dueDateController.text = _formatDate(pickedDate);
  }
}

// Date Formatter
String _formatDate(DateTime date) {
  final DateFormat formatter = DateFormat('MMM d, yyyy');
  return formatter.format(date);
}
