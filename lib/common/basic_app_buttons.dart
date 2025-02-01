import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const BasicAppButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 6,
        backgroundColor: Colors.blue,
        minimumSize: const Size(300, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
