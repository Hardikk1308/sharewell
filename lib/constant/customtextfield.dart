import 'package:flutter/material.dart';

const kTextFormFieldDecoration = InputDecoration(
  border: OutlineInputBorder(),
  labelText: 'Enter your text',
  hintText: 'Enter your text',
);

class CustomFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: kTextFormFieldDecoration.copyWith(
          labelText: labelText,
          hintText: hintText,
        ),
        validator: validator,
      ),
    );
  }
}
