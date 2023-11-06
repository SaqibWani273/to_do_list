import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/model/task.dart';
import 'package:to_do_list/utility/update_task.dart';
import 'package:to_do_list/view_model/task_provider.dart';
import 'package:another_flushbar/flushbar.dart';

import '../../constants/other_constants.dart';

class TasksList extends StatelessWidget {
  TasksList({
    super.key,
    required this.taskList,
    required this.ref,
  });

  final List<Task> taskList;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        //  await Future.delayed(Duration(seconds: 13));
        await ref.read(taskProvider.notifier).setTasksList();
      },
      child: ListView.builder(
          itemCount: taskList.length,
          itemBuilder: (context, index) => Card(
                elevation: 0,
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.15)
                    .withBlue(150),
                child: Dismissible(
                  confirmDismiss: (direction) => showDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Are you sure?'),
                      content: const Text('Do you want to delete this task?'),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('No'),
                        ),
                        CupertinoDialogAction(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  ),
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
                  onDismissed: (direction) async {
                    //used this pub package as default snackbar was not showing
                    //due to bottom nav bar and floating action button
                    await Flushbar(
                      message: 'Task Deleted !',
                      duration: const Duration(seconds: 3),
                      flushbarPosition: FlushbarPosition.BOTTOM,
                      flushbarStyle: FlushbarStyle.FLOATING,
                      backgroundGradient: const LinearGradient(
                        colors: [
                          Colors.black,
                          Colors.black,
                        ],
                      ),
                    )
                        // Show the Flushbar.
                        .show(context);
                    if (context.mounted) {
                      ref
                          .read(taskProvider.notifier)
                          .deleteTask(taskList[index], context);
                    }
                  },
                  child: ListTile(
                    //show icon conditionally if incomplete or if complete
                    leading: GestureDetector(
                      onTap: () => ref
                          .read(taskProvider.notifier)
                          .toggleIsCompleteStatus(taskList[index]),
                      child: !taskList[index].isCompleted
                          ? Icon(
                              Icons.radio_button_unchecked,
                              color: Colors.blue.withRed(200),
                            )
                          : const Icon(Icons.check_circle, color: Colors.green),
                    ),
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
                              Row(
                                children: [
                                  const Icon(Icons.access_time),
                                  Text(formatTime(taskList[index].taskTime)),
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
              )),
    );
  }
}
