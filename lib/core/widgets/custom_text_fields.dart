import 'package:flutter/material.dart';

/// A reusable custom text input field with standard styling and validation
class CustomTextField extends StatelessWidget {
  /// Creates a [CustomTextField] instance
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.validator,
  });

  /// Controller for managing text input.
  final TextEditingController controller;

  /// Placeholder label for the input field
  final String label;

  /// Indicates whether the text should be obscured (e.g. for passwords).
  final bool obscureText;

  /// Custom validator function
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(labelText: label),
    );
  }
}
