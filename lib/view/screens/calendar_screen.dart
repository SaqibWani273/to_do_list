import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../model/task.dart';
import '../../utility/date_&_time_format.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  final List<Task>? tasksList;
  const CalendarScreen({super.key, required this.tasksList});
  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();

  final _lastDay = DateTime.now().add(const Duration(days: 365));
  final _firstDay = DateTime.now().subtract(const Duration(days: 365));

  void showTasksForDay(DateTime selectedDay) {
    final tasks = widget.tasksList?.where((task) {
      return task.taskDate.day == selectedDay.day;
    }).toList();

    //  log("tasks = ${tasks!.length}");
    showModalBottomSheet(
      //add color to the bottom sheet
      backgroundColor: Theme.of(context).primaryColorLight,
      context: context,
      builder: (context) {
        return tasks == null || tasks.isEmpty
            ? const Center(child: Text('No tasks for this day'))
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
            //to change focus of the day
            selectedDayPredicate: (day) => isSameDay(_focusedDay, day),
            headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                )),
            //to get the no.of events in a particular day
            //it shows the dots only,thats y used calendarbuilders
            eventLoader: (day) {
              return widget.tasksList!
                  .where((task) =>
                      task.taskDate.day == day.day &&
                      task.taskDate.month == day.month &&
                      task.taskDate.year == day.year)
                  .toList();
            },
            // Use `CalendarStyle` to customize the UI
            calendarStyle: CalendarStyle(
                markersAlignment: Alignment.bottomRight,
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                )),
            //to convert the no.of events in a particular day
            //into a circle with the number
            calendarBuilders:
                CalendarBuilders(markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                return Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      events.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                );
              }
              return null;
            }),

            onDaySelected: (selectedDay, focusedDay) {
              showTasksForDay(focusedDay);

              setState(() {
                _focusedDay = selectedDay;
              });
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
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text("${task.taskName}  |  ${formatTime(task.taskTime)}"),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 05),
          child: Text(task.description),
        ),
        trailing: task.isCompleted
            ? Icon(
                Icons.check_box,
                color: Theme.of(context).primaryColorDark,
              )
            : Icon(
                Icons.check_box_outline_blank,
                color: Theme.of(context).disabledColor,
              ),
      ),
    );
  }
}
