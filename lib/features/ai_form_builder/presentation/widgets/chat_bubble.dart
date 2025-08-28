import 'package:flutter/gestures.dart'; // Import gestures for TapGestureRecognizer
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

import '../../domain/ai_form_builder_chat_model.dart';

/// Chat Bubble widget

class ChatBubble extends StatelessWidget {
  /// using AiFormBuilderChatModel to create data instance

  final AiFormBuilderChatModel chat;

  /// chat bubble design constructor

  const ChatBubble({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    // Determine alignment and color based on whether it's a user message
    final alignment =
        chat.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = chat.isUser ? Colors.blue[100] : Colors.grey[200];
    final crossAxisAlignment =
        chat.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Container(
      alignment: alignment,
      child: Card(
        color: color,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              _buildMessageText(
                context,
                chat.message,
              ), // Use _buildMessageText for clickable links
              const SizedBox(height: 4),
              // Display timestamp (optional, you can add it if needed)
              // Text(
              //   DateFormat('hh:mm a').format(chat.timestamp),
              //   style: Theme.of(context).textTheme.bodySmall,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageText(BuildContext context, String message) {
    final List<TextSpan> spans = [];
    final RegExp urlRegex = RegExp(
      r'(https?:\/\/[^\s]+)',
      caseSensitive: false,
    );

    message.splitMapJoin(
      urlRegex,
      onMatch: (Match match) {
        final String url = match.group(0)!;
        spans.add(
          TextSpan(
            text: url,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () async {
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      // Handle error, e.g., show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch $url')),
                      );
                    }
                  },
          ),
        );
        return ''; // Return empty string to prevent default splitting
      },
      onNonMatch: (String text) {
        spans.add(TextSpan(text: text));
        return ''; // Return empty string to prevent default splitting
      },
    );

    return RichText(
      text: TextSpan(
        children: spans,
        style: Theme.of(context).textTheme.bodyMedium, // Default text style
      ),
    );
  }
}
