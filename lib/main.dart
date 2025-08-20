import 'package:ai_chat/app.dart';
import 'package:ai_chat/core/services/firebase_messaging_service.dart';
import 'package:ai_chat/core/services/initialization_service.dart';
import 'package:ai_chat/core/utils/logger.dart';
import 'package:ai_chat/features/auth/provider/auth_providers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Top Level function to handle background messages

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Moved here
  AppLogger.init(); // Moved here
  // Moved here
  final container = ProviderContainer();

  try {
    await container.read(initializationServiceProvider).initialize();
  } catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(body: Center(child: Text('Initialization failed: $e'))),
      ),
    );
    return;
  }

  container.read(authControllerProvider.notifier).checkInitialAuthState();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
