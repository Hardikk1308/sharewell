import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const BasicAppButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
      style: ElevatedButton.styleFrom(
      ),
    );
  }
}
