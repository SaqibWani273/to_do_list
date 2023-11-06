import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/image_constants.dart';
import '../../model/task.dart';
import '../../view_model/task_provider.dart';
import '../widgets/custom_image_view.dart';
import '../widgets/tasks_list.dart';
import 'add_task_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final List<Task>? tasksList;
  const HomeScreen({super.key, required this.tasksList});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<Task>? tasksList;
  @override
  void initState() {
    tasksList = widget.tasksList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //whenever the state in taskProvider changes
    tasksList = ref.watch<List<Task>>(taskProvider);

    return Stack(
      children: [
        tasksList == null || tasksList!.isEmpty
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
            : TasksList(
                taskList: tasksList!,
                ref: ref,
              ),
        customFloatingButton(ref: ref),
      ],
    );
  }

  ///
}

class customFloatingButton extends StatelessWidget {
  const customFloatingButton({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
        ));
  }
}
