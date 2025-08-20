import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/auth_controller.dart';
import '../application/auth_state.dart';
import '../infrastructure/auth_repository.dart';

/// its carry all functionality of AuthRepository model functions.
final authRepositoryProvider = Provider((ref) => AuthRepository(ref));

/// authStateProvider will check users recent status and carries User information.
/// AuthStateProvider will use for all kind of calling in controlller
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final repo = ref.watch(authRepositoryProvider);
    return AuthController(repo, ref);
  },
);

/// Obscure text provider which will be use in login and signup
final obscureTextProvider = StateProvider<bool>((ref) => true);
