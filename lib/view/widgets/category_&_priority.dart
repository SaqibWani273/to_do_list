// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:to_do_list/constants/other_constants.dart';

import '../../model/task.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;

  const CategoryWidget({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: getCategoryColor(category).withOpacity(0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(category.name),
      ),
    );
  }
}

class PriorityWidget extends StatelessWidget {
  final Priority priority;
  const PriorityWidget({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    // var priority;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: getPriorityColor(priority).withOpacity(0.5)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text('${priority.name}  priority'),
      ),
    );
  }
}
