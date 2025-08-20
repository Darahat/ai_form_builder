import 'package:ai_chat/core/errors/exceptions.dart';
import 'package:ai_chat/features/ai_chat/provider/ai_chat_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/ai_chat_model.dart';
import '../infrastructure/ai_chat_repository.dart';

/// Used to indicate loading status in the UI
final aiChatLoadingProvider = StateProvider<bool>((ref) => false);

/// Main Ai Chat Controller connected to Hive-backed AiChatRepository
class AiChatController extends StateNotifier<AsyncValue<List<AiChatModel>>> {
  final AiChatRepository _repo;

  /// ref is a riverpod object which used by providers to interact with other providers and life cycle
  /// of the application
  /// example ref.read, ref.write etc
  final Ref ref;

  /// AiChatController Constructor to call it from outside
  AiChatController(this._repo, this.ref) : super(const AsyncValue.loading()) {
    loadAiChat();
  }

  /// Load all aiChats from repository and update the state
  Future<void> loadAiChat() async {
    if (!mounted) return;
    state = const AsyncValue.loading();
    try {
      final aiChats = await _repo.getAiChat();
      if (!mounted) return;
      /// Filter for incomplete aiChats and set the data state
      state = AsyncValue.data(aiChats);
    } catch (e, s) {
      if (!mounted) return;
      /// If loading fails, set the error state
      state = AsyncValue.error(e, s);
    }
  }

  /// Load all aiChats from repository
  // Future<void> getAiChats() async {
  //   ref.read(aiChatLoadingProvider.notifier).state = true;

  //   final aiChats = await _repo.aiChats();
  //   state = aiChats.where((aiChat) => aiChat.isCompleted == false).toList();

  //   ref.read(aiChatLoadingProvider.notifier).state = false;
  // }

  /// Add a new aiChat and reload list
  Future<void> addAiChat(
    String usersText,
    String systemPrompt,
    String userPromptPrefix,
    String systemQuickReplyPrompt,
    String errorMistralRequest,
  ) async {
    /// Get The current list of aiChats from the state's value
    final currentAiChats = state.value ?? [];
    final usersMessage = await _repo.addAiChat(usersText);
    if (usersMessage == null) return;

    if (!mounted) return;
    state = AsyncValue.data([...currentAiChats, usersMessage]);
    try {
      /// Get AI Reply
      final mistralService = ref.read(mistralServiceProvider);
      final aiReplyText = await mistralService.generateQuickReply(
        usersText,
        systemPrompt,
        userPromptPrefix,
        systemQuickReplyPrompt,
        errorMistralRequest,
      );

      /// Update the message with AI's reply
      final updatedMessage = usersMessage.copyWith(
        replyText: aiReplyText,
        isReplied: true,
        isSeen: true,

        /// mark as Seen by AI
      );
      await _repo.updateAiChat(usersMessage.id!, updatedMessage);
      if (!mounted) return;
      state = AsyncValue.data(
        state.value!.updated(usersMessage.id!, updatedMessage),
      );
    } catch (e, s) {
      throw ServerException(
        '🚀 ~Save on hive of mistral reply from (ai_chat_controller.dart) $e and this is $s',
      );
    }
    // finally {
    //   final updatedMessage = usersMessage.copyWith(
    //     replyText: "Sorry, I couldn't get a response",
    //     isReplied: true,
    //   );
    //   await _repo.updateAiChat(usersMessage.id!, updatedMessage);
    //   state = AsyncValue.data(
    //     state.value!.updated(usersMessage.id!, updatedMessage),
    //   );
    // }
  }

  /// Toggle a aiChat and reload list
  Future<void> toggleIsSeenChat(String id) async {
    final currentChats = state.value ?? [];
    if (currentChats.isEmpty) return;
    await _repo.toggleIsSeenChat(id);

    // final chatToUpdate = currentChats.firstWhere((t) => t.id == id);

    /// changing aiChat according to which tid is toggled check and updated using copy with
    /// which generates copy of that exact object which is toggled
    ///
    final updatedList =
        currentChats.map((chat) {
          if (chat.id == id) {
            return chat.copyWith(isSeen: !(chat.isSeen ?? false));
          }
          return chat;
        }).toList();

    /// Update the state with the new list
    if (!mounted) return;
    state = AsyncValue.data(updatedList);
  }

  /// Update chat status value of is it replied
  Future<void> toggleIsRepliedChat(String id) async {
    final currentChats = state.value ?? [];
    if (currentChats.isEmpty) return;

    await _repo.toggleIsRepliedChat(id);
    final chatToUpdate = currentChats.firstWhere((chat) => chat.id == id);
    final updatedList = currentChats.updated(
      id,
      chatToUpdate.copyWith(isReplied: !(chatToUpdate.isReplied ?? false)),
    );
    if (!mounted) return;
    state = AsyncValue.data(updatedList);
  }

  /// Remove a aiChat and reload list
  Future<void> removeAiChat(String id) async {
    final currentAiChats = state.value ?? [];

    await _repo.removeChat(id);
    if (!mounted) return;
    state = AsyncValue.data(
      currentAiChats.where((chat) => chat.id != id).toList(),
    );
  }

  /// Edit a aiChat and reload list
  Future<void> editAiChat(String id, String newText) async {
    final currentAiChats = state.value ?? [];
    if (currentAiChats.isEmpty) return;
    await _repo.editUserChat(id, newText);
    final aiChatToUpdate = currentAiChats.firstWhere((t) => t.id == id);

    /// changing aiChat according to which tid is toggled check and updated using copy with
    /// which generates copy of that exact object which is toggled
    final updatedList = currentAiChats.updated(
      id,
      aiChatToUpdate.copyWith(chatTextBody: newText),
    );

    /// Update the state with the new list
    if (!mounted) return;
    state = AsyncValue.data(updatedList);
  }
}
