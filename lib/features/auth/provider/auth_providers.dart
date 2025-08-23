import 'package:ai_form_builder/core/services/hive_service.dart';
import 'package:ai_form_builder/core/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/auth_controller.dart';
import '../application/auth_state.dart';
import '../infrastructure/auth_repository.dart';

/// its carry all functionality of AuthRepository model functions.
final authRepositoryProvider = Provider((ref) {
  // final hiveService = ref.watch(hiveServiceProvider);
  final hiveService = ref.watch(hiveServiceProvider);
  final logger = ref.watch(appLoggerProvider);
  return AuthRepository(hiveService, ref, logger);
});

/// authStateProvider will check users recent status and carries User information.
/// AuthStateProvider will use for all kind of calling in controlller
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    // 2. Get the real authBox from the HiveService
    final authBox = ref.watch(hiveServiceProvider).authBox;
    final repo = ref.watch(authRepositoryProvider);
    final logger = ref.watch(appLoggerProvider);
    return AuthController(repo, authBox, ref, logger);
  },
);

/// Obscure text provider which will be use in login and signup
final obscureTextProvider = StateProvider<bool>((ref) => true);
