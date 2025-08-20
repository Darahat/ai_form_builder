import 'package:flutter/material.dart';

/// A reusable custom button used across the application.
class CustomButton extends StatelessWidget {
  /// Creates a [CustomButton] instance
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
  });

  /// Callback executed when the button is pressed
  final VoidCallback? onPressed;

  /// The widget displayed inside the button
  final Widget child;

  /// Optional button color.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(onPressed: onPressed, child: child),
    );
  }
}
