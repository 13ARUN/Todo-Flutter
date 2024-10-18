import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/task_model.dart';

part 'form_fields.dart';
part 'buttons.dart';
part 'date_picker.dart';

class TaskInput extends StatefulWidget {
  const TaskInput({
    super.key,
    required this.action,
    this.task,
  });

  final String action;
  final TaskModel? task;

  @override
  State<TaskInput> createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
  final _formGlobalKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initialData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  void _initialData() {
    if (widget.action == 'edit' && widget.task != null) {
      final task = widget.task!;
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _dueDateController.text = task.date;
    } else {
      _dueDateController.text = _formatDate(DateTime.now());
    }
  }

  //* Return Task Inputs
  void _submitTaskData() {
    final enteredTitle = _titleController.text.trim();
    final enteredDescription = _descriptionController.text.trim();
    final selectedDate = _dueDateController.text;

    final taskToReturn = TaskModel(
      id: widget.action == 'add' ? DateTime.now().toString() : widget.task!.id,
      title: enteredTitle,
      description: enteredDescription,
      date: selectedDate,
      isCompleted: widget.action == 'add' ? false : widget.task!.isCompleted,
    );

    Navigator.pop(context, taskToReturn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.action == "add" ? "Add a new task" : "Update task",
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Form(
              key: _formGlobalKey,
              child: Column(
                children: [
                  // Task Title field
                  buildTitleField(_titleController),
                  const SizedBox(height: 15),
                  // Task Description field
                  buildDescriptionField(_descriptionController),
                  const SizedBox(height: 15),
                  // Task Due Date field
                  buildDueDateField(_dueDateController,
                      () => _selectDate(context, _dueDateController)),
                  const SizedBox(height: 25),
                  // Task Form Buttons
                  buildFormButtons(
                      context, _formGlobalKey, _submitTaskData, widget.action),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
