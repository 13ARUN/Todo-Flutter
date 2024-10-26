import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/services/providers/tasks_provider.dart';
import 'package:todo/utils/logger/logger.dart';

part 'buttons.dart';
part 'form_fields.dart';

class TaskInput extends ConsumerStatefulWidget {
  const TaskInput({
    super.key,
    required this.action,
    this.task,
  });

  final String action;
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
    _initialData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _initialData() {
    if (widget.action == 'edit' && widget.task != null) {
      final task = widget.task!;
      _titleController.text = task.title;
      _descriptionController.text = task.description;
    }
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(date);
  }

  //* Return Task Inputs
  void _submitTaskData() {
    logger.t("Executing _submitTaskData method");
    final enteredTitle = _titleController.text.trim();
    final enteredDescription = _descriptionController.text.trim();

    final taskToReturn = TaskModel(
      id: widget.action == 'add' ? DateTime.now().toString() : widget.task!.id,
      title: enteredTitle,
      description: enteredDescription,
      date: widget.action == 'add'
          ? _formatDate(DateTime.now())
          : widget.task!.date,
      isCompleted: widget.action == 'add' ? false : widget.task!.isCompleted,
    );

    Navigator.pop(context, taskToReturn);
  }

  @override
  Widget build(BuildContext context) {
    logger.t("Build Method Executing");
    final existingTasks = ref.watch(tasksProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.action == 'add' ? "Add a new task" : "Update task",
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 25,
            ),
            child: Form(
              key: _formGlobalKey,
              child: Column(
                children: [
                  // Task Title field
                  buildTitleField(
                    _titleController,
                    widget.action,
                    widget.task,
                    existingTasks,
                  ),
                  const SizedBox(height: 15),
                  // Task Description field
                  buildDescriptionField(
                    _descriptionController,
                  ),
                  const SizedBox(height: 15),
                  // Task Form Buttons
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
