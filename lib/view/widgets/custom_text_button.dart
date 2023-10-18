import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  // final void Function() onPressed;
  final VoidCallback onPressed;
  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.background.withOpacity(0.3)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge, //bodyLargeWhiteA700,
      ),
    );
  }
}
