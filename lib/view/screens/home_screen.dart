import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/image_constants.dart';
import '../../model/task.dart';
import '../../utility/get_tasks_list.dart';
import '../../view_model/task_provider.dart';
import '../widgets/custom_image_view.dart';
import '../widgets/place_holder_widget.dart';
import '../widgets/tasks_list.dart';
import 'add_task_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<List<Task>?> tasksList;
  @override
  void initState() {
    tasksList = ref.read(taskProvider.notifier).getTasksList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //whenever the state in taskProvider changes futureBuilder would be called
    ref.watch<List<Task>>(taskProvider);
    log('rebuild homescreen');
    //  getTasksList();
    return FutureBuilder<List<Task>?>(
      future: tasksList,
      builder: (BuildContext context, AsyncSnapshot<List<Task>?> snapshot) {
        if (snapshot.hasData) {
          return Stack(
            //   alignment: Alignment.bottomLeft,
            children: [
              //  taskList.isEmpty
              snapshot.data!.isEmpty
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
                  : TasksList(taskList: snapshot.data!, ref: ref),
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

        return Shimmer.fromColors(
          baseColor:
              Theme.of(context).colorScheme.onBackground.withOpacity(0.05),
          highlightColor: Theme.of(context).scaffoldBackgroundColor,
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => const PlaceHolderWidget(),
          ),
        );
      },
    );

    ///
  }
}
