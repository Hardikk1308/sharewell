import 'package:flutter/material.dart';

const kTextFormFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
);

class CustomFormField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  CustomFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    required this.controller,
    this.validator,
    required this.icon,
  });
  final border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
    borderRadius: BorderRadius.circular(15.0),
  );

  @override
  _CustomFormFieldState createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        decoration: kTextFormFieldDecoration.copyWith(
          labelText: widget.labelText,
          hintText: widget.hintText,
          prefixIcon: Icon(widget.icon),
          focusedBorder: widget.border,
          border: widget.border,
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _toggleObscureText,
                )
              : null,
        ),
        validator: widget.validator,
      ),
    );
  }
}
