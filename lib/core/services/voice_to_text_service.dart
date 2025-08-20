import 'dart:async';

import 'package:ai_chat/core/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// voice to text related service
class VoiceToTextService {
  /// use riverpod reference
  final Ref ref;
  final stt.SpeechToText _speech = stt.SpeechToText();

  ///calling the provider
  final isListeningProvider = StateProvider<bool>((ref) => false);

  ///made the constructor
  VoiceToTextService(this.ref);

  /// Helper function to process recognized text
  String? processRecognizedText(String text) {
    if (text.isEmpty) return null;
    final lowerCaseText = text.toLowerCase();
    bool hasAmPm =
        lowerCaseText.contains('am') || lowerCaseText.contains('p.m.');

    /// A simple regex to find numbers that look like time
    RegExp timeRegex = RegExp(r'\b(\d{1,2})(:\d{2})?\b');
    Iterable<Match> matches = timeRegex.allMatches(lowerCaseText);
    if (matches.isNotEmpty) {
      /// if the text has a time-like number but no "am" or "pm"
      if (!hasAmPm &&
          !lowerCaseText.contains('evening') &&
          !lowerCaseText.contains('night')) {
        /// Here you could have logic to ask the user for clarification
        /// for Example, return a special string that your UI can catch
        return "$text(clarification needed: AM or PM?)";
      }
    }
    return text;
  }

  /// its speech listener lisen to text
  Future<String?> listenForText() async {
    ref.read(isListeningProvider.notifier).state = true;
    final available = await _speech.initialize();
    if (!available) {
      ref.read(isListeningProvider.notifier).state = false;
      return null;
    }

    String? processedText = '';
    await _speech.listen(
      onResult: (result) {
        final resultText = result.recognizedWords;
        processedText = processRecognizedText(resultText);
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 6),
      onSoundLevelChange: (level) {
        // use for visual waveform feedback, optional
        AppLogger.error('🚀 ~ Check Sound level', level);
      },
    );

    /// Wait until listening ends
    await Future.doWhile(() async {
      await Future.delayed(const Duration(microseconds: 500));
      return _speech.isListening;
    });
    ref.read(isListeningProvider.notifier).state = false;
    return processedText;
  }
}
