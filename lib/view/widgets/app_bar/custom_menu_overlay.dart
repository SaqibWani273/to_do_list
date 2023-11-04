import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/constants/other_constants.dart';

import '../../../view_model/task_provider.dart';

void showCustomMenu(BuildContext context, WidgetRef ref) {
////use some other time
  // final overlaState = Overlay.of(context);
  // final overlay = OverlayEntry(
  //   builder: (context) => Positioned(
  //       top: 100,
  //       left: 100,
  //       child: Container(
  //         child: Text('hello'),
  //       )),
  // );
  // overlaState.insert(overlay);
  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(0.0, 100.0, 100.0, 0.0),
    items: [
      PopupMenuItem(
        child: TextButton.icon(
          icon: Icon(Icons.all_inbox),
          onPressed: () {
            ref.read(taskProvider.notifier).listTasks(ListTasksBy.all);
            Navigator.pop(context);
          },
          label: Text('All Tasks'),
        ),
      ),
      PopupMenuItem(
        child: TextButton.icon(
          icon: Icon(Icons.done),
          onPressed: () {
            ref.read(taskProvider.notifier).listTasks(ListTasksBy.completed);
            Navigator.pop(context);
          },
          label: Text('Completed Tasks'),
        ),
      ),
      PopupMenuItem(child: Text('List By : ')),
      PopupMenuItem(
        child: TextButton(onPressed: () {}, child: Text('Date')
            // child: DropdownButton(
            //   value: 'Priority',
            //   items: [
            //     DropdownMenuItem(
            //       child: Text('Priority'),
            //     ),
            //     DropdownMenuItem(
            //       child: Text('Date'),
            //     ),
            //   ],
            //   onChanged: (value) {},
            // ),
            ),
      ),
      PopupMenuItem(
        child: TextButton(
          onPressed: () {},
          child: Text('Priority'),
        ),
      ),
      PopupMenuItem(
        child: TextButton(
          onPressed: () {},
          child: Text('Date'),
        ),
      ),
    ],
  );
}
