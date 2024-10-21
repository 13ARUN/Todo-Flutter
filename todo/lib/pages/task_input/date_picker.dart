part of 'task_input.dart';

String _formatDate(DateTime date) {
  final DateFormat formatter = DateFormat('MMM dd, yyyy');
  return formatter.format(date);
}

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
