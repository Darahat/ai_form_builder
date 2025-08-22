import 'package:ai_form_builder/core/services/hive_service.dart';
import 'package:ai_form_builder/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Initialization Service class
/// where all kind of Initialization takes places

class InitializationService {
  /// Ref is used to any provider or service to connect with other provider/service
  final Ref ref;

  /// Initialization Service Constructor
  InitializationService(this.ref);

  /// Main Initialize function
  Future<void> initialize() async {
    /// Ensure Flutter binding is initialized

    /// Register background message handler
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.appAttest,
    );
    await HiveService.init();
  }
}

/// initializationServiceProvider provider variable
final initializationServiceProvider = Provider<InitializationService>(
  (ref) => InitializationService(ref),
);
