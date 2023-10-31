import 'package:flutter/material.dart';

class FullProfilePic extends StatelessWidget {
  final String url;
  final bool isUser;
  const FullProfilePic({super.key, required this.url, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: MediaQuery.of(context).size.height * 0.8,
      width: double.infinity,
      child: Hero(
        tag: 'profile',
        child: isUser
            ? Image.network(
                url,
                fit: BoxFit.contain,
              )
            : Image.asset(
                url,
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}
