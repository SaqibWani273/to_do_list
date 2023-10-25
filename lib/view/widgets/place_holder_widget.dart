import 'package:flutter/material.dart';

class PlaceHolderWidget extends StatelessWidget {
  const PlaceHolderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //generated it from bard
    return Card(
      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        title: Container(
          height: 20,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        subtitle: Container(
          height: 10,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
