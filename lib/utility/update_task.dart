import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/constants/edit_task.dart';

import '../model/task.dart';
import '../view/screens/add_task_screen.dart';
import '../view_model/task_provider.dart';

void updateTask({
  required TaskEnum value,
  required WidgetRef ref,
  required Task currentTask,
  required BuildContext context,
}) {
  if (value == TaskEnum.Edit) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddTaskScreen(
        onSave: (editedTask) {
          ref.read(taskProvider.notifier).editTask(currentTask, editedTask);
        },
        task: currentTask,
      ),
    ));
  } else if (value == TaskEnum.Delelte) {
    ref.read(taskProvider.notifier).deleteTask(currentTask);
  } else {
    ref.read(taskProvider.notifier).toggleIsCompleteStatus(currentTask);
  }
}
