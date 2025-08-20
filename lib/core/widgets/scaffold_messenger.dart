import 'package:flutter/material.dart';

///to handle all scaffold messenger widget
void scaffoldMessenger(BuildContext context, next) {
  // Show a well-styled SnackBar with clear messaging
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        next.message,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 6.0,

      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}
