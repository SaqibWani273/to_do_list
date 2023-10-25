import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/constants/edit_task.dart';
import 'package:to_do_list/model/task.dart';
import 'package:to_do_list/utility/update_task.dart';
import 'package:to_do_list/view_model/task_provider.dart';

class TasksList extends StatelessWidget {
  const TasksList({
    super.key,
    required this.taskList,
    required this.ref,
  });

  final List<Task> taskList;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        //    physics: NeverScrollableScrollPhysics(),
        itemCount: taskList.length,
        itemBuilder: (context, index) => Card(
              elevation: 0,
              color: Theme.of(context)
                  .colorScheme
                  .onBackground
                  .withOpacity(0.15)
                  .withBlue(150),
              child: Dismissible(
                key: UniqueKey(),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) {
                  ref.read(taskProvider.notifier).deleteTask(taskList[index]);
                },
                child: ListTile(
                  //show icon conditionally if incomplete or if complete
                  leading: !taskList[index].isCompleted
                      ? Icon(
                          Icons.help,
                          color: Colors.blue.withRed(200),
                        )
                      : const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(taskList[index].taskName),
                  subtitle: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today),
                                Text('${taskList[index].taskDate.toLocal()}'
                                    .split(' ')[0]),
                              ],
                            ),
                            const Row(
                              children: [
                                Icon(Icons.access_time),
                                Text('3:00'),
                              ],
                            ),
                          ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.category),
                              Text(' ${taskList[index].taskCategory.name}'),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.low_priority),
                              Text('${taskList[index].taskPriority.name}')
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<TaskEnum>(
                      onSelected: (value) => updateTask(
                          value: value,
                          ref: ref,
                          currentTask: taskList[index],
                          context: context),
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => <PopupMenuEntry<TaskEnum>>[
                            ...popMenuItemList
                                .map((taskEnum) => PopupMenuItem(
                                      child: Text('${taskEnum.name}'),
                                      value: taskEnum,
                                    ))
                                .toList(),
                          ]),
                ),
              ),
            ));
  }
}
