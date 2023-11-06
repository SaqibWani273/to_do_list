import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do_list/view/widgets/tasks_list.dart';
import 'dart:developer';

import '../../model/task.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  final List<Task>? tasksList;
  const CalendarScreen({super.key, required this.tasksList});
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();

  final _lastDay = DateTime.now().add(Duration(days: 365));
  final _firstDay = DateTime.now().subtract(Duration(days: 365));

  void showTasksForDay(DateTime selectedDay) {
    final tasks = widget.tasksList?.where((task) {
      return task.taskDate.day == selectedDay.day;
    }).toList();

    //  log("tasks = ${tasks!.length}");
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return tasks == null || tasks.isEmpty
            ? Center(child: Text('No tasks for this day'))
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return TaskCard(task: tasks[index]);
                },
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(_firstDay.year, _firstDay.month, 1),
            lastDay: DateTime(_lastDay.year, _lastDay.month, _lastDay.day),
            selectedDayPredicate: (day) => isSameDay(_focusedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              showTasksForDay(focusedDay);

              log(" selectedDay = $selectedDay , focusedDay = $focusedDay");
              setState(() {
                _focusedDay = selectedDay;
              });
              // (DateTime date) {
              //   setState(() {
              //     _focusedDay = date;
              //   });
              // };
            },
          ),
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(task.taskName),
        subtitle: Text(DateFormat('EEEE, MMMM d, yyyy').format(task.taskDate)),
      ),
    );
  }
}

// class Task {
//   final String title;
//   final DateTime date;

//   Task({required this.title, required this.date});
// }
