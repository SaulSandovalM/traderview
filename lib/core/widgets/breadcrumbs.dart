import 'package:flutter/material.dart';

class Breadcrumbs extends StatelessWidget {
  final String backText;
  final VoidCallback onPressed;
  final String text;

  const Breadcrumbs({
    super.key,
    required this.backText,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Text(
            backText,
            style: const TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 5),
        const Text('/'),
        const SizedBox(width: 5),
        Text(text),
      ],
    );
  }
}
