import 'dart:io';

import 'package:flutter/material.dart';

class FullProfilePic extends StatelessWidget {
  final imagePath;

  const FullProfilePic({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: MediaQuery.of(context).size.height * 0.8,
      width: double.infinity,
      child: Hero(
        tag: 'profile',
        child: imagePath != null
            ? Image.file(
                File(imagePath!),
                fit: BoxFit.contain,
              )
            : Image.asset(
                'assets/images/unknown_user.png',
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}
