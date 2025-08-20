import 'package:ai_chat/features/app_settings/application/settings_controller.dart';
import 'package:ai_chat/features/app_settings/application/settings_state.dart';
import 'package:ai_chat/features/app_settings/infrastructure/settings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// its carry all functionality of AuthRepository functions
final settingsRepositoryProvider = Provider((ref) => SettingsRepository());

/// settingsControllerProvider will use for all kind of controller function calling
/// Provider for the Settings Controller
/// Changed to AsyncNotifierProvider to handle asynchronous initialization
/// The state will be an AsyncValue<`SettingState`>.
final settingsControllerProvider = AsyncNotifierProvider<
  SettingsController,
  SettingState
>(() {
  /// No need to manually watch the repository here ists done in the controllers build method
  /// removed the AppLogger.debug call from here as it is a side effect in a provider definition
  return SettingsController();
});
/// Obscure settings provider which will be use in setting