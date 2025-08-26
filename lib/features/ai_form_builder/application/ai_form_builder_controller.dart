import 'package:ai_form_builder/core/errors/exceptions.dart';
import 'package:ai_form_builder/core/services/hive_service.dart';
import 'package:ai_form_builder/core/utils/form_generator.dart';
import 'package:ai_form_builder/features/ai_form_builder/provider/ai_form_builder_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/ai_form_builder_chat_model.dart';
import '../infrastructure/ai_form_builder_repository.dart';

/// Used to indicate loading status in the UI
final formBuilderChatLoadingProvider = StateProvider<bool>((ref) => false);

/// Main Ai Chat Controller connected to Hive-backed AiFormBuilderChatRepository
class AiFormBuilderChatController
    extends StateNotifier<AsyncValue<List<AiFormBuilderChatModel>>> {
  final AiFormBuilderChatRepository _repo;
  HiveService hiveService;

  /// ref is a riverpod object which used by providers to interact with other providers and life cycle
  /// of the application
  /// example ref.read, ref.write etc
  final Ref ref;

  /// AiFormBuilderChatController Constructor to call it from outside
  AiFormBuilderChatController(this._repo, this.ref, this.hiveService)
    : super(const AsyncValue.loading()) {
    loadAiFormBuilderChat();
  }

  /// Load all aiFormBuilderChats from repository and update the state
  Future<void> loadAiFormBuilderChat() async {
    if (!mounted) return;
    state = const AsyncValue.loading();
    try {
      final aiFormBuilderChats = await _repo.getAiFormBuilderChat();
      if (!mounted) return;

      /// Filter for incomplete aiFormBuilderChats and set the data state
      state = AsyncValue.data(aiFormBuilderChats);
    } catch (e, s) {
      if (!mounted) return;

      /// If loading fails, set the error state
      state = AsyncValue.error(e, s);
    }
  }

  /// Load all aiFormBuilderChats from repository
  // Future<void> getAiFormBuilderChats() async {
  //   ref.read(aiFormBuilderChatLoadingProvider.notifier).state = true;

  //   final aiFormBuilderChats = await _repo.aiFormBuilderChats();
  //   state = aiFormBuilderChats.where((aiFormBuilderChat) => aiFormBuilderChat.isCompleted == false).toList();

  //   ref.read(aiFormBuilderChatLoadingProvider.notifier).state = false;
  // }

  /// Add a new aiFormBuilderChat and reload list
  Future<void> addAiFormBuilderChat(
    String usersText,
    String systemPrompt,
  ) async {
    /// Get The current list of aiFormBuilderChats from the state's value
    final currentAiFormBuilderChats = state.value ?? [];
    final usersMessage = await _repo.addAiFormBuilderChat(usersText);
    if (usersMessage == null) return;

    if (!mounted) return;
    state = AsyncValue.data([...currentAiFormBuilderChats, usersMessage]);
    try {
      /// Get AI Reply
      final mistralService = ref.read(mistralServiceProvider);

      // 1. Get the chat history from the state
      final chatHistory =
          state.value
              ?.map((chat) {
                return [
                  {"role": "user", "content": chat.chatTextBody ?? ""},
                  {"role": "assistant", "content": chat.replyText ?? ""},
                ];
              })
              .expand((element) => element)
              .toList() ??
          [];

      final aiReplyText = await mistralService.generateFormBuilderQuestions(
        usersText,
        chatHistory,
        systemPrompt,
      );

      final form = await FormGenerator.parseAndSaveForm(
        ref,
        hiveService,
        aiReplyText,
      );
      final replyText =
          form != null
              ? "Your form has been created! You can access it here: https://your-app.com/form/${form.id}"
              : aiReplyText;

      /// Update the message with AI's reply
      final updatedMessage = usersMessage.copyWith(
        replyText: replyText,
        isReplied: true,
        isSeen: true,

        /// mark as Seen by AI
      );
      await _repo.updateAiFormBuilderChat(usersMessage.id!, updatedMessage);
      if (!mounted) return;
      state = AsyncValue.data(
        state.value!.updated(usersMessage.id!, updatedMessage),
      );
    } catch (e, s) {
      throw ServerException(
        '🚀 ~Save on hive of mistral reply from (ai_form_builder_controller.dart) $e and this is $s',
      );
    }
  }

  /// Toggle a aiFormBuilderChat and reload list
  Future<void> toggleIsSeenChat(String id) async {
    final currentChats = state.value ?? [];
    if (currentChats.isEmpty) return;
    await _repo.toggleIsSeenChat(id);

    // final chatToUpdate = currentChats.firstWhere((t) => t.id == id);

    /// changing aiFormBuilderChat according to which tid is toggled check and updated using copy with
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

  /// Remove a aiFormBuilderChat and reload list
  Future<void> removeAiFormBuilderChat(String id) async {
    final currentAiFormBuilderChats = state.value ?? [];

    await _repo.removeChat(id);
    if (!mounted) return;
    state = AsyncValue.data(
      currentAiFormBuilderChats.where((chat) => chat.id != id).toList(),
    );
  }

  /// Edit a aiFormBuilderChat and reload list
  Future<void> editAiFormBuilderChat(String id, String newText) async {
    final currentAiFormBuilderChats = state.value ?? [];
    if (currentAiFormBuilderChats.isEmpty) return;
    await _repo.editUserChat(id, newText);
    final aiFormBuilderChatToUpdate = currentAiFormBuilderChats.firstWhere(
      (t) => t.id == id,
    );

    /// changing aiFormBuilderChat according to which tid is toggled check and updated using copy with
    /// which generates copy of that exact object which is toggled
    final updatedList = currentAiFormBuilderChats.updated(
      id,
      aiFormBuilderChatToUpdate.copyWith(chatTextBody: newText),
    );

    /// Update the state with the new list
    if (!mounted) return;
    state = AsyncValue.data(updatedList);
  }
}
