import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../model/task.dart';

class AddTaskScreen extends StatefulWidget {
  //optional field task will be received when edit task in pressed
  final Task? task;
  final Function(Task) onSave;

  const AddTaskScreen({super.key, required this.onSave, this.task});

  @override
  AddTaskScreenState createState() => AddTaskScreenState();
}

class AddTaskScreenState extends State<AddTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _taskNameController;
  DateTime _selectedDate = DateTime.now();
  Priority _selectedPriority = Priority.medium;
  Category _selectedCategory = Category.personal;

  @override
  void initState() {
    _taskNameController = TextEditingController();
    if (widget.task != null) {
      _selectedDate = widget.task!.taskDate;
      _selectedCategory = widget.task!.taskCategory;
      _selectedPriority = widget.task!.taskPriority;
      _taskNameController.text = widget.task!.taskName;
    }
    super.initState();
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextFormField(
                controller: _taskNameController,
                decoration: const InputDecoration(labelText: 'Task Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task name';
                  }
                  return null;
                },
              ),
              ListTile(
                title: const Text('Task Date'),
                //splits date and time & then select only date
                subtitle: Text('${_selectedDate.toLocal()}'.split(' ')[0]),
                trailing: IconButton(
                    onPressed: () {
                      //remove any active keyboard
                      FocusScope.of(context).unfocus();
                      _selectDate(context);
                    },
                    icon: const Icon(Icons.calendar_month)),
              ),
              //add task time here but only when the date is set

              DropdownButtonFormField<Priority>(
                value: _selectedPriority,
                items: Priority.values
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Task Priority'),
              ),
              DropdownButtonFormField<Category>(
                value: _selectedCategory,
                items: Category.values
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Task Category'),
              ),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final taskId = const Uuid().v4();
                    final newTask = Task(
                      taskName: _taskNameController.text,
                      taskDate: _selectedDate,
                      taskPriority: _selectedPriority,
                      taskCategory: _selectedCategory,
                      isCompleted: false,
                      id: taskId,
                    );

                    widget.onSave(newTask);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
