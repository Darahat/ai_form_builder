import 'package:ai_form_builder/core/services/voice_to_text_service.dart';
import 'package:ai_form_builder/features/auth/application/auth_state.dart';
import 'package:ai_form_builder/features/auth/domain/user_model.dart';
import 'package:ai_form_builder/features/auth/infrastructure/auth_repository.dart';
import 'package:ai_form_builder/features/auth/provider/auth_providers.dart';
import 'package:ai_form_builder/features/utou_chat/application/utou_chat_controller.dart';
import 'package:ai_form_builder/features/utou_chat/domain/utou_chat_model.dart';
import 'package:ai_form_builder/features/utou_chat/infrastructure/utou_chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// UToUChat repository that interacts with Hive
final uToUChatRepositoryProvider = Provider<UToUChatRepository>(
  (ref) => UToUChatRepository(),
);

/// Get authentication provider functions
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref),
);

/// Get User Provider infos
final usersProvider = StreamProvider<List<UserModel>>((ref) {
  // final authRepo = ref.watch(authRepositoryProvider);
  // return authRepo.getUsers();
  final authState = ref.watch(authControllerProvider);
  if (authState is Authenticated) {
    final authRepo = ref.watch(authRepositoryProvider);
    return authRepo.getUsers();
  } else {
    return Stream.value([]);
  }
});

/// Voice input for adding uToUChat
final voiceToTextProvider = Provider<VoiceToTextService>((ref) {
  return VoiceToTextService(ref);
});

/// Indicates whether voice is recording
final isListeningProvider = StateProvider<bool>((ref) => false);

/// to check The AISummary is expanded or not
final isExpandedSummaryProvider = StateProvider<bool>((ref) => false);

/// to check The Floating button is expanded or not
final isExpandedFabProvider = StateProvider<bool>((ref) => false);

/// Controller for uToUChat logic and Hive access
final uToUChatControllerProvider =
    StateNotifierProvider<UToUChatController, AsyncValue<List<UToUChatModel>>>((
      ref,
    ) {
      final repo = ref.watch(uToUChatRepositoryProvider);
      return UToUChatController(repo, ref);
    });

/// messagesProvider check is user authenticated
/// take the utouchat repository data from firebase
/// getting currentUserId from authstate
/// and returning getMessage function with current user id/sender and otherUserId/
final messagesProvider = StreamProvider.family<List<UToUChatModel>, String>((
  ref,
  otherUserId,
) {
  final authState = ref.read(authControllerProvider);
  if (authState is Authenticated) {
    final repo = ref.watch(uToUChatRepositoryProvider);
    final currentUserId = authState.uid!;
    return repo.getMessages(currentUserId, otherUserId);
  } else {
    return Stream.value([]);
  }
});
