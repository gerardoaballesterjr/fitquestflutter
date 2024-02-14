import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText, labelText;
  final bool obscureText;
  final Function(String)? onChanged;
  final String? error;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.obscureText,
    this.onChanged,
    this.error,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        labelText: widget.labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // hintText: widget.hintText,
        errorText: widget.error
            ?.replaceFirst(widget.error![0], widget.error![0].toUpperCase()),
        contentPadding: const EdgeInsets.all(15),
      ),
      onChanged: widget.onChanged,
    );
  }
}
