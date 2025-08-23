import 'package:ai_form_builder/core/utils/logger.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sound Service Provider which will cause of notification sound
final soundServiceProvider = Provider<SoundService>((ref) {
  final logger = ref.watch(appLoggerProvider);
  return SoundService(logger);
});

/// Sound Service class
class SoundService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AppLogger _appLogger;

  /// SoundService constructor
  SoundService(this._appLogger);

  ///This function calling _audioPlayer for play sound
  Future<void> playNotificationSound() async {
    try {
      /// Assuming you have a notification sound in your assets/audio folder
      await _audioPlayer.play(AssetSource('audio/notification.mp3'));
    } catch (e) {
      _appLogger.error("Error Playing sound: $e");
    }
  }
}
