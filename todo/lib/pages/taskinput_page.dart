import 'package:flutter/material.dart';

class TaskInput extends StatefulWidget {
  const TaskInput({super.key, required this.action});

  final String action;

  @override
  State<TaskInput> createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
  final _formGlobalKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _duedateController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _duedateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _duedateController.text = DateTime.now().toString();
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formGlobalKey,
            child: Column(
              children: [
                //* Task Title field
                TextFormField(
                  controller: _titleController,
                  maxLength: 25,
                  decoration: const InputDecoration(
                    label: Text('Title'),
                    hintText: 'Enter Task Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter a task title";
                    }
                    if (value.trim() == '') {
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
                    label: Text('Description'),
                    hintText: 'Enter Task Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                //* Task Due Date field
                TextFormField(
                  controller: _duedateController,
                  decoration: const InputDecoration(
                    label: Text('Due Date'),
                    hintText: 'Enter Task Due Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 107, 92, 121)),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          if (_formGlobalKey.currentState!.validate()) {
                            _formGlobalKey.currentState!.reset();
                          }
                        },
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 69, 17, 117)),
                        ),
                        child: widget.action == 'add'
                            ? const Text('Add')
                            : const Text('Update'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
