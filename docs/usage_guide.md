# Usage Guide

The **Flutter Starter Kit** is designed to be modular and easy to customize. Here's how to use it:

## Enabling/Disabling Features

To enable or disable features, simply import the corresponding module in `lib/app.dart` and `lib/core/config/`.

Example:
To disable the `notifications` feature, remove the import and initialization in `main.dart`.

```dart
import 'package:starter_kit/features/notifications/notifications.dart';
```
