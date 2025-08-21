import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Mistral LLM Service implementation
class MistralService {
  ///OPENROUTER_AI_API_KEY you may find in .env
  static final _apiKey = dotenv.env['OPENROUTER_AI_API_KEY']!;
  static const _endpoint = 'https://openrouter.ai/api/v1/chat/completions';

  /// Mistral LLM API calling procedure as like as regular jquery
  Future<String> generateSummary(String taskList) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "mistralai/mistral-7b-instruct:free",
        "messages": [
          {
            "role": "system",
            "content":
                "You are a helpful assistant that generates task summaries and plans.",
          },
          {
            "role": "user",
            "content":
                "Based on the following task list, generate a summary and suggest smart daily plan:\n$taskList",
          },
        ],
        "temperature": 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception(
        'Failed to get response from Mistral: ${response.statusCode} ${response.body}',
      );
    }
  }

  /// Generate quick reply like as chat for ai chat features
  Future<String> generateQuickReply(
    String userMessage,
    String systemPrompt,
    String userPromptPrefix,
    String systemQuickReplyPrompt,
    String errorMistralRequest,
  ) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "mistralai/mistral-7b-instruct:free",
        "messages": [
          {"role": "system", "content": systemQuickReplyPrompt},
          {"role": "user", "content": userMessage},
        ],
        "temperature": 0.8,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception(
        'Failed to get response from Mistral: ${response.statusCode} ${response.body}',
      );
    }
  }

  /// Generate quick reply like as chat for ai chat features
  Future<String> generateFormBuilderQuestions(
    String userMessage,
    String systemPrompt,
    String userPromptPrefix,
    String systemQuickReplyPrompt,
    String errorMistralRequest,
  ) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "mistralai/mistral-7b-instruct:free",
        "messages": [
          {"role": "system", "content": systemQuickReplyPrompt},
          {"role": "user", "content": userMessage},
        ],
        "temperature": 0.8,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception(
        'Failed to get response from Mistral: ${response.statusCode} ${response.body}',
      );
    }
  }
}
