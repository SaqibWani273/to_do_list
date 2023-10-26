import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/image_constants.dart';
import '../../model/task.dart';
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
  late List<Task>? tasksList;
  bool loadingData = true;
  @override
  void initState() {
    loadTaskList();

    super.initState();
  }

  Future<void> loadTaskList() async {
    tasksList = await ref.read(taskProvider.notifier).getTasksList();
    //to stop showing shimmer effect in ui
    setState(() {
      loadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //whenever the state in taskProvider changes
    tasksList = ref.watch<List<Task>>(taskProvider);

    if (loadingData) {
      return Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.05),
        highlightColor: Theme.of(context).scaffoldBackgroundColor,
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => const PlaceHolderWidget(),
        ),
      );
    } else {
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
                  parentContext: context,
                ),
          customFloatingButton(ref: ref),
        ],
      );
    }

    ///
  }
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
