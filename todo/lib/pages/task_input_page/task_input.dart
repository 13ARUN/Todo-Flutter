import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/providers/tasks_provider.dart';
import 'package:todo/utils/logger/logger.dart';

part 'buttons.dart';
part 'form_fields.dart';

/// A widget that allows users to input and edit task details.
///
/// This widget is used to create a new task or edit an existing task.
/// It provides input fields for the task's title and description,
/// as well as buttons to submit the data.
class TaskInput extends ConsumerStatefulWidget {
  const TaskInput({
    super.key,
    required this.action,
    this.task,
  });

  /// The action to perform, either 'add' or 'edit'.
  ///
  /// - 'add': Indicates that a new task is being created.
  /// - 'edit': Indicates that an existing task is being modified.
  final String action;

  /// The task to be edited, if applicable.
  ///
  /// This optional parameter is used only when the action is 'edit'.
  /// It contains the details of the task to be modified.
  final TaskModel? task;

  @override
  ConsumerState<TaskInput> createState() => _TaskInputState();
}

class _TaskInputState extends ConsumerState<TaskInput> {
  final _formGlobalKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  static final logger = getLogger('_TaskInputState');

  @override
  void initState() {
    super.initState();
    _initialData(); // Initialize form fields with existing task data if editing.
  }

  @override
  void dispose() {
    _titleController
        .dispose(); // Dispose of the title controller when not needed.
    _descriptionController
        .dispose(); // Dispose of the description controller when not needed.
    super.dispose();
  }

  /// Initializes the input fields with the current task data if in edit mode.
  void _initialData() {
    if (widget.action == 'edit' && widget.task != null) {
      final task = widget.task!;
      _titleController.text = task.title; // Set the title controller text.
      _descriptionController.text =
          task.description; // Set the description controller text.
    }
  }

  /// Formats the date into a more readable string format.
  ///
  /// This method takes a [DateTime] object and returns a formatted date string.
  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(date); // Return the formatted date string.
  }

  /// Submits the task data and returns it to the previous screen.
  void _submitTaskData() {
    logger.t("Executing _submitTaskData method");
    final enteredTitle =
        _titleController.text.trim(); // Trim white spaces from title input.
    final enteredDescription = _descriptionController.text
        .trim(); // Trim white spaces from description input.

    final taskToReturn = TaskModel(
      id: widget.action == 'add'
          ? '' // ID will be created by API.
          : widget.task!.id,
      title: enteredTitle, // Set the title for the task.
      description: enteredDescription, // Set the description for the task.
      date: widget.action == 'add'
          ? _formatDate(
              DateTime.now()) // Will be replaced by creation date from API
          : widget.task!.date, // Keep the existing date if editing.
      isCompleted: widget.action == 'add'
          ? false
          : widget.task!.isCompleted, // Keep completion status.
    );

    Navigator.pop(context,
        taskToReturn); // Return the new or updated task to the previous screen.
  }

  @override
  Widget build(BuildContext context) {
    logger.t("Build Method Executing");
    final existingTasks =
        ref.watch(tasksProvider); // Watch for existing tasks in the provider.

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.action == 'add'
              ? "Add a new task"
              : "Update task", // Set the app bar title based on action.
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Form(
              key: _formGlobalKey, // Assign the global key to the form.
              child: Column(
                children: [
                  buildTitleField(
                    _titleController,
                    widget.action,
                    widget.task,
                    existingTasks,
                  ),
                  const SizedBox(height: 15),
                  buildDescriptionField(
                    _descriptionController,
                  ),
                  const SizedBox(height: 15),
                  buildFormButtons(
                    context,
                    _formGlobalKey,
                    _submitTaskData,
                    widget.action,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
