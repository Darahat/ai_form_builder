import 'package:ai_form_builder/features/auth/provider/auth_providers.dart';
import 'package:ai_form_builder/features/utou_chat/presentation/widgets/chat_bubble.dart'; // Import the new widget
import 'package:ai_form_builder/features/utou_chat/provider/utou_chat_providers.dart';
import 'package:ai_form_builder/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Forget Password Page presentation
class UToUChatView extends ConsumerStatefulWidget {
  /// it will take receiverId from user list
  final String receiverId;

  /// It will get receiverName
  final String receiverName;

  /// Forget Password page class constructor
  const UToUChatView({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  ConsumerState<UToUChatView> createState() => _UToUChatViewConsumerState();
}

class _UToUChatViewConsumerState extends ConsumerState<UToUChatView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    final chatsAsync = ref.watch(messagesProvider(widget.receiverId));
    final currentUser = ref.watch(authControllerProvider);
    // final chatRoomId = getChatRoomId(_auth.currentUser?.uid, widget.receiverId);

    /// get Firestore message updates
    ref.listen(messagesProvider(widget.receiverId), (previous, next) {
      if (next.asData != null) {
        _scrollToBottom();
      }
    });

    /// Listen to changes in the chat list when new data arrives scroll to the bottom
    ref.listen(uToUChatControllerProvider, (previous, next) {
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
              // Mark messages as read
              for (var chat in chats) {
                if (chat.receiverId == currentUser.uid) {
                  ref
                      .read(uToUChatControllerProvider.notifier)
                      .toggleIsReadChat(
                        chat.id,
                        chat.receiverId!,
                        chat.senderId!,
                      );
                }
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final isCurrentUser = chat.senderId == currentUser.uid;
                  return ChatBubble(chat: chat, isCurrentUser: isCurrentUser);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
        _buildMessageInput(
          ref,
          _textController,
          context,
          currentUser.uid ?? '',
        ),
      ],
    );
  }

  Widget _buildMessageInput(
    WidgetRef ref,
    TextEditingController textController,
    BuildContext context,
    String currentUserId,
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
                      .read(uToUChatControllerProvider.notifier)
                      .addUToUChat(
                        text,
                        systemPrompt,
                        userPromptPrefix,
                        systemQuickReplyPrompt,
                        errorMistralRequest,
                        currentUserId,
                        widget.receiverId,
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
                    .read(uToUChatControllerProvider.notifier)
                    .addUToUChat(
                      text,
                      systemPrompt,
                      userPromptPrefix,
                      systemQuickReplyPrompt,
                      errorMistralRequest,
                      currentUserId,
                      widget.receiverId,
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
