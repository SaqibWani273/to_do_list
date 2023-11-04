import 'package:flutter/material.dart';

Widget customMenuBarWidget() {
  return PopupMenuButton(
    itemBuilder: (context) => [
      PopupMenuItem(
        child: TextButton.icon(
          icon: Icon(Icons.home),
          onPressed: () {},
          label: Text('Home'),
        ),
      ),
      PopupMenuItem(
        child: TextButton.icon(
          icon: Icon(Icons.settings),
          onPressed: () {},
          label: Text('Settings'),
        ),
      ),
    ],
  );
}
