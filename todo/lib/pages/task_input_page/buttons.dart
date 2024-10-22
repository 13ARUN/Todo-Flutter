part of 'task_input.dart';

Widget buildFormButtons(BuildContext context, GlobalKey<FormState> formKey,
    VoidCallback submitTaskData, String action) {
  return Row(
    children: [
      Expanded(
        child: FilledButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
      const SizedBox(width: 25),
      Expanded(
        child: FilledButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              submitTaskData();
            }
          },
          child: Text(action == 'add' ? 'Add' : 'Update'),
        ),
      ),
    ],
  );
}
