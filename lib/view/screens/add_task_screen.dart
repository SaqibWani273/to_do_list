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

  late TextEditingController _descriptionController;
  DateTime _selectedDate = DateTime.now();
  Priority _selectedPriority = Priority.medium;
  Category _selectedCategory = Category.personal;
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    _taskNameController = TextEditingController();
    _descriptionController = TextEditingController();
    if (widget.task != null) {
      _selectedDate = widget.task!.taskDate;
      _selectedCategory = widget.task!.taskCategory;
      _selectedPriority = widget.task!.taskPriority;
      _taskNameController.text = widget.task!.taskName;
      _selectedTime = widget.task!.taskTime;

      _descriptionController.text = widget.task!.description;
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: false,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
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
          child: SingleChildScrollView(
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
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      labelText: 'Short task description(2 line max)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task Description';
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
                ListTile(
                  title: const Text('Task Time'),
                  //splits date and time & then select only date
                  subtitle:
                      Text('${_selectedTime.hour}:${_selectedTime.minute}'),
                  trailing: IconButton(
                      onPressed: () {
                        //remove any active keyboard
                        FocusScope.of(context).unfocus();
                        _selectTime(context);
                      },
                      icon: const Icon(Icons.access_time)),
                ),
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
                        taskTime: _selectedTime,
                        description: _descriptionController.text,
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
      ),
    );
  }
}
