import 'package:flutter/material.dart';

import '../pages/login_page.dart';

/// AuthScreen Scaffold class
class AuthScreen extends StatelessWidget {
  /// AuthScreen Scaffold class constructor

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Dream Flutter Starter Kit")),
      body: const LoginPage(),
    );
  }
}
