import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/task_model.dart';

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

  //* Date Formatter
  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMM d, yyyy');
    return formatter.format(date);
  }

  //* Date picker Helper
  Future<void> _selectDate() async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(now.year + 1, now.month, now.day),
    );

    if (pickedDate != null) {
      setState(() {
        _dueDateController.text = _formatDate(pickedDate);
      });
    }
  }

  //* Return Task Inputs
  void _submitTaskData() {
    final enteredTitle = _titleController.text.trim();
    final enteredDescription = _descriptionController.text.trim();
    final selectedDate = _dueDateController.text;

    final tasktoReturn = TaskModel(
      id: widget.action == 'add' ? DateTime.now().toString() : widget.task!.id,
      title: enteredTitle,
      description: enteredDescription,
      date: selectedDate,
      isCompleted: widget.action == 'add' ? false : widget.task!.isCompleted,
    );
    Navigator.pop(context, tasktoReturn);
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
                  //* Task Title field
                  TextFormField(
                    autofocus: widget.action == 'add' ? true : false,
                    controller: _titleController,
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
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //* Task Description field
                  TextFormField(
                    controller: _descriptionController,
                    minLines: 1,
                    maxLines: 3,
                    maxLength: 120,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter Task Description',
                      suffixIcon: Icon(Icons.description_outlined),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //* Task Due Date field
                  TextFormField(
                    controller: _dueDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      label: Text('Due Date'),
                      hintText: 'Enter Task Description',
                      suffixIcon: Icon(
                        Icons.calendar_month,
                      ),
                    ),
                    onTap: _selectDate,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  //* Task Form Buttons
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            if (_formGlobalKey.currentState!.validate()) {
                              _submitTaskData();
                            }
                          },
                          child:
                              Text(widget.action == 'add' ? 'Add' : 'Update'),
                        ),
                      ),
                    ],
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
