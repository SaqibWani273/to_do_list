import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/constants/other_constants.dart';
import 'package:to_do_list/model/task.dart';

import '../../../view_model/task_provider.dart';

void showCustomMenu(
  BuildContext context,
  WidgetRef ref,
) {
  showMenu(
    color: Theme.of(context).scaffoldBackgroundColor,
    context: context,
    position: RelativeRect.fromLTRB(0.0, 100.0, 100.0, 0.0),
    items: [
      ...ShowList.values
          .map(
            (e) => PopupMenuItem(
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ref.read(taskProvider.notifier).listBy(e);
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            e.name.toUpperCase(),
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(
                            e == ShowList.completed
                                ? Icons.done
                                : Icons.list_rounded,
                            color: Colors.black,
                          ),
                        ]))),
          )
          .toList(),

      // PopupMenuItem(
      //   child: TextButton(
      //     style: TextButton.styleFrom(
      //       textStyle: TextStyle(color: Colors.black),
      //     ),
      //     onPressed: () {
      //       //  ref.read(taskProvider.notifier).listTasks(ListTasksBy.all);
      //       Navigator.pop(context);
      //     },
      //     child: Row(mainAxisSize: MainAxisSize.min, children: [
      //       Text('All Tasks',),
      //       Icon(Icons.list_rounded),
      //     ]),
      //   ),
      // ),
      // PopupMenuItem(
      //   child: TextButton.icon(
      //     label: Text('Completed Tasks'),
      //     icon: Icon(Icons.done),
      //     onPressed: () {
      //       // ref.read(taskProvider.notifier).listTasks(ListTasksBy.completed);
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      PopupMenuItem(
          child: Text(
        'Category : ',
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      )),

      ////

      ...Category.values
          .map((e) => PopupMenuItem(
                  child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.read(taskProvider.notifier).listBy(e);
                },
                child: Text(
                  e.name.toUpperCase(),
                  style: TextStyle(color: Colors.black),
                ),
              )))
          .toList(),
    ],
  );
}
