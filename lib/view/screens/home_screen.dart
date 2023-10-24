import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/constants/image_constants.dart';
import 'package:to_do_list/view/screens/add_task_screen.dart';
import 'package:to_do_list/view/widgets/custom_image_view.dart';
import 'package:to_do_list/view_model/task_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskList = ref.watch(taskProvider);

    return Stack(
      //   alignment: Alignment.bottomLeft,
      children: [
        taskList.isEmpty
            ? Container(
                width: double.maxFinite,
                padding: const EdgeInsets.only(
                  left: 52,
                  top: 68,
                  right: 52,
                ),
                child: Column(
                  children: [
                    CustomImageView(
                      svgPath: ImageConstant.imgChecklistrafiki,
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: 227,
                    ),
                    const SizedBox(height: 14),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.titleLarge,
                        children: const [
                          TextSpan(text: 'Tap '),
                          TextSpan(
                              text: ' + ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              )),
                          TextSpan(text: ' to add your First Task'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 13),
                  ],
                ),
              )
            : ListView(
                children: taskList
                    .map((task) => Card(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.05),
                          child: Dismissible(
                            key: Key(task.taskName),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              // Handle task deletion here
                              //   tasks.removeAt(index);
                            },
                            child: ListTile(
                              title: Text(task.taskName),
                              subtitle: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today),
                                            Text('${task.taskDate.toLocal()}'
                                                .split(' ')[0]),
                                          ],
                                        ),
                                        Row(
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
                                          Icon(Icons.category),
                                          Text(' ${task.taskCategory.name}'),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.low_priority),
                                          Text('${task.taskPriority.name}')
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              trailing:
                                  Icon(Icons.check_circle, color: Colors.green),
                            ),
                            //  ListTile(
                            //   leading: CircleAvatar(
                            //     child: Text(task.taskName[0]),
                            //   ),
                            //   title: Text(
                            //     task.taskName,
                            //     style: TextStyle(
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 18,
                            //     ),
                            //   ),
                            //   subtitle: Text(
                            //     '${task.taskDate} | ${task.taskCategory} | ${task.taskPriority} | time here',
                            //     style: TextStyle(
                            //       fontSize: 14,
                            //       color: Colors.grey,
                            //     ),
                            //   ),
                            //   trailing: IconButton(
                            //     onPressed: () {},
                            //     icon: Icon(Icons.more_vert),
                            //   ),
                            // )
                            // ListTile(
                            //   title: Text(task.taskName),
                            //   subtitle: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text('Date: ${task.taskDate}'),
                            //       Text('Category: ${task.taskCategory}'),
                            //       Text('Priority: ${task.taskPriority}'),
                            //       Text('Time: 3:000'),
                            //     ],
                            //   ),
                            //   trailing:
                            //       Icon(Icons.check_circle, color: Colors.green),
                            // ),
                          ),
                        ))
                    .toList(),
              ),
        Positioned(
            bottom: 100,
            right: 20,
            height: 65,
            width: 65,
            child: FloatingActionButton(
              elevation: 20,
              child: Icon(
                Icons.add,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTaskScreen(
                        onSave: (newTask) {
                          ref.read(taskProvider.notifier).addNewTask(newTask);
                        },
                      ),
                    ));
              },
            ))
      ],
    );
  }
}
