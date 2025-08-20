import 'package:ai_chat/core/utils/logger.dart';
import 'package:audioplayers/audioplayers.dart';

/// Perform Notification sound
class SoundService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  ///This function calling _audioPlayer for play sound
  Future<void> playNotificationSound() async {
    try {
      /// Assuming you have a notification sound in your assets/audio folder
      await _audioPlayer.play(AssetSource('audio/notification.mp3'));
    } catch (e) {
      AppLogger.error("Error Playing sound: $e");
    }
  }
}
