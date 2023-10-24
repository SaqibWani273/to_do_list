import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/image_constants.dart';
import '../../model/task.dart';
import '../../utility/get_tasks_list.dart';
import '../../view_model/task_provider.dart';
import '../widgets/custom_image_view.dart';
import '../widgets/tasks_list.dart';
import 'add_task_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskList = ref.watch(taskProvider);

    getTasksList();
    return FutureBuilder<List<Task>?>(
      future: getTasksList(),
      builder: (BuildContext context, AsyncSnapshot<List<Task>?> data) {
        if (data.hasData) {
          return Stack(
            //   alignment: Alignment.bottomLeft,
            children: [
              //  taskList.isEmpty
              data.data!.isEmpty
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
                                TextSpan(text: ' to add First Task'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 13),
                        ],
                      ),
                    )
                  : TasksList(taskList: taskList, ref: ref),
              Positioned(
                  bottom: 100,
                  right: 20,
                  height: 65,
                  width: 65,
                  child: FloatingActionButton(
                    elevation: 20,
                    child: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTaskScreen(
                              onSave: (newTask) {
                                ref
                                    .read(taskProvider.notifier)
                                    .addNewTask(newTask);
                              },
                            ),
                          ));
                    },
                  ))
            ],
          );
        }

        return Text("loading");
      },
    );

    ///

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
                          TextSpan(text: ' to add First Task'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 13),
                  ],
                ),
              )
            : TasksList(taskList: taskList, ref: ref),
        Positioned(
            bottom: 100,
            right: 20,
            height: 65,
            width: 65,
            child: FloatingActionButton(
              elevation: 20,
              child: const Icon(
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
