import 'package:flutter/material.dart';

class TaskInput extends StatefulWidget {
  const TaskInput({super.key, required this.action});

  final String action;

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
    _dueDateController.text = DateTime.now().toString().split(' ')[0];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.action == 'add'
            ? const Text('Add Task')
            : const Text('Edit Task'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
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
                    suffixIcon: Icon(Icons.calendar_month, color: Colors.deepPurple,),
                  ),
                  onTap: _selectDate,
                ),
                const SizedBox(
                  height: 30,
                ),
                //* Task Form Buttons
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(
                          fixedSize: WidgetStatePropertyAll(
                            Size.fromHeight(45),
                          ),
                          foregroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 0, 0, 0)),
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 234, 224, 231)),
                        ),
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
                            _formGlobalKey.currentState!.reset();
                          }
                        },
                        style: const ButtonStyle(
                          fixedSize: WidgetStatePropertyAll(
                            Size.fromHeight(45),
                          ),
                          backgroundColor: WidgetStatePropertyAll(
                              Colors.deepPurple),
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
