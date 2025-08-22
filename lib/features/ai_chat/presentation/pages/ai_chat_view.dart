import 'package:ai_form_builder/features/ai_chat/provider/ai_chat_providers.dart';
import 'package:ai_form_builder/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/chat_bubble.dart'; // Import the new widget

/// Forget Password Page presentation
class AiChatView extends ConsumerStatefulWidget {
  /// Forget Password page class constructor
  const AiChatView({super.key});

  @override
  ConsumerState<AiChatView> createState() => _AiChatViewConsumerState();
}

class _AiChatViewConsumerState extends ConsumerState<AiChatView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    /// Using a post-frame callback ensures that the list has been built/updated
    /// before we try to scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatsAsync = ref.watch(aiChatControllerProvider);

    /// Listen to changes in the chat list when new data arrives scroll to the bottom
    ref.listen(aiChatControllerProvider, (previous, next) {
      if (next is AsyncData) {
        /// Check if a message was added
        final prevLength = previous?.asData?.value.length ?? 0;
        final currentLength = next.value?.length ?? 0;
        if (currentLength > prevLength) {
          _scrollToBottom();
        }
      }
    });
    return Column(
      children: [
        Expanded(
          child: chatsAsync.when(
            data: (chats) {
              /// Initial scroll when data first loads
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.jumpTo(
                    _scrollController.position.maxScrollExtent,
                  );
                }
              });
              return ListView.builder(
                controller: _scrollController,
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return ChatBubble(chat: chat);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
        _buildMessageInput(ref, _textController, context),
      ],
    );
  }

  Widget _buildMessageInput(
    WidgetRef ref,
    TextEditingController textController,
    BuildContext context,
  ) {
    final systemPrompt = AppLocalizations.of(context)!.systemSummaryPrompt;
    final userPromptPrefix = AppLocalizations.of(context)!.userSummaryPrompt;
    final systemQuickReplyPrompt =
        AppLocalizations.of(context)!.systemQuickReplyPrompt;
    final errorMistralRequest =
        AppLocalizations.of(context)!.errorMistralRequest;
    final typeMessage = AppLocalizations.of(context)!.typeMessage;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: typeMessage,
                border: OutlineInputBorder(),
              ),
              onSubmitted: (text) {
                /// Allow submitting with keyboard
                if (text.isNotEmpty) {
                  ref
                      .read(aiChatControllerProvider.notifier)
                      .addAiChat(
                        text,
                        systemPrompt,
                        userPromptPrefix,
                        systemQuickReplyPrompt,
                        errorMistralRequest,
                      );
                  textController.clear();
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final text = textController.text;
              if (text.isNotEmpty) {
                ref
                    .read(aiChatControllerProvider.notifier)
                    .addAiChat(
                      text,
                      systemPrompt,
                      userPromptPrefix,
                      systemQuickReplyPrompt,
                      errorMistralRequest,
                    );
                textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
