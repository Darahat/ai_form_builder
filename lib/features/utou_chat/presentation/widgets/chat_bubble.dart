import 'package:ai_form_builder/features/utou_chat/domain/utou_chat_model.dart';
import 'package:flutter/material.dart';

/// Chat Bubble
class ChatBubble extends StatelessWidget {
  /// get the chat object
  final UToUChatModel chat;

  /// check is currentUser or not
  final bool isCurrentUser;

  /// ChatBubble Constructor
  const ChatBubble({
    super.key,
    required this.chat,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    // A simple chat bubble design
    return Column(
      children: [
        // User's message
        Container(
          alignment:
              isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Card(
            color: isCurrentUser ? Colors.blue[100] : Colors.grey[200],
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment:
                    isCurrentUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                children: [
                  Text(chat.chatTextBody ?? ''),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isCurrentUser && (chat.isDelivered ?? false))
                        const Icon(
                          Icons.done_all,
                          size: 16,
                          color: Colors.blue,
                        ),
                      if (isCurrentUser && (chat.isRead ?? false))
                        const Icon(
                          Icons.remove_red_eye,
                          size: 16,
                          color: Colors.green,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
