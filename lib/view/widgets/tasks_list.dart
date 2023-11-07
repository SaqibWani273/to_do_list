import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/constants/theme/custom_theme.dart';
import 'package:to_do_list/model/task.dart';
import 'package:to_do_list/utility/update_task.dart';
import 'package:to_do_list/view/widgets/category_&_priority.dart';
import 'package:to_do_list/view_model/task_provider.dart';
import 'package:another_flushbar/flushbar.dart';

import '../../constants/other_constants.dart';
import '../../utility/date_&_time_format.dart';

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
                color: Theme.of(context).scaffoldBackgroundColor,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        margin: const EdgeInsets.all(10),
                        elevation: 05,
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withBlue(200),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            taskList[index].taskName,
                            style: theme.textTheme.bodyLarge,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.15)
                              .withBlue(150),
                        ),
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
                                : const Icon(Icons.check_circle,
                                    color: Colors.green),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(taskList[index].description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium),
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${dayAndMonth(taskList[index].taskDate)} ${formatTime(taskList[index].taskTime)}'),
                                    CategoryWidget(
                                        category: taskList[index].taskCategory),
                                  ]),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                //    mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  PriorityWidget(
                                    priority: taskList[index].taskPriority,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Text(
                                          timeLeft(taskList[index].taskDate,
                                              taskList[index].taskTime),
                                          style: timeLeft(
                                                      taskList[index].taskDate,
                                                      taskList[index]
                                                          .taskTime) ==
                                                  timeExpired
                                              ? TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  color: Colors.red
                                                      .withOpacity(0.8),
                                                )
                                              : null)),
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
                              icon:
                                  const Icon(Icons.arrow_forward_ios_outlined),
                              itemBuilder: (context) =>
                                  <PopupMenuEntry<TaskEnum>>[
                                    ...popMenuItemList
                                        .map((taskEnum) => PopupMenuItem(
                                              value: taskEnum,
                                              child: Text(taskEnum.name),
                                            ))
                                        .toList(),
                                  ]),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
    );
  }
}
