import 'package:flutter/material.dart';
import 'package:todo/models/task_model.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class TaskInput extends StatefulWidget {
  final String action;
  final TaskModel? task;

  const TaskInput({super.key, required this.action, this.task});

  @override
  State<TaskInput> createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
  final _formGlobalKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.action == 'edit' && widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _dueDateController.text = widget.task!.date;
    } else {
      _dueDateController.text = DateTime.now().toString().split(' ')[0];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  //* Date picker Helper
  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dueDateController.text = pickedDate.toString().split(' ')[0];
      });
    }
  }

  //* Return Task Inputs
  void _submitTaskData() {
    final enteredTitle = _titleController.text.trim();
    final enteredDescription = _descriptionController.text.trim();
    final selectedDate = _dueDateController.text;

    final tasktoReturn = TaskModel(
      id: widget.action == 'add' ? uuid.v4() : widget.task!.id,
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
        title: widget.action == 'add'
            ? const Text('Add Task')
            : const Text('Edit Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Form(
            key: _formGlobalKey,
            child: Column(
              children: [
                //* Task Title field
                TextFormField(
                  autofocus: true,
                  controller: _titleController,
                  maxLength: 25,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter Task Title',
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple)),
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
                  maxLines: 5,
                  maxLength: 180,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter Task Description',
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple)),
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
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple)),
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
                        child: widget.action == 'add'
                            ? const Text('Add')
                            : const Text('Update'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
