import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../config/api_config.dart';

class ChatMessage {
  final String role; // 'user' or 'assistant'
  final String content;
  final DateTime timestamp;

  ChatMessage({required this.role, required this.content, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();
}

class ChatbotService {
  static final ChatbotService _instance = ChatbotService._internal();
  factory ChatbotService() => _instance;
  ChatbotService._internal();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.groqApiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConfig.groqApiKey}',
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  final List<ChatMessage> _conversationHistory = [];

  List<ChatMessage> get conversationHistory => List.unmodifiable(_conversationHistory);

  void clearHistory() {
    _conversationHistory.clear();
  }

  void initializeWithDiseaseContext(String diseaseName, String description) {
    _conversationHistory.clear();

    final contextMessage =
        '''
The farmer has just detected: $diseaseName

Disease Information:
$description

Please greet the farmer and offer to help with any questions about this disease or general crop care.
Respond in both Urdu and English.
''';

    _conversationHistory.add(ChatMessage(role: 'system', content: contextMessage));
  }

  Future<String> sendMessage(String userMessage) async {
    try {
      // Add user message to history
      _conversationHistory.add(ChatMessage(role: 'user', content: userMessage));

      // Prepare messages for API
      final messages = [
        {'role': 'system', 'content': ApiConfig.systemPrompt},
        ..._conversationHistory
            .map(
              (msg) => {'role': msg.role == 'system' ? 'user' : msg.role, 'content': msg.content},
            )
            .toList(),
      ];

      // Make API call
      final response = await _dio.post(
        '',
        data: {
          'model': ApiConfig.defaultModel,
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 1000,
        },
      );

      if (response.statusCode == 200) {
        final assistantMessage = response.data['choices'][0]['message']['content'] as String;

        // Add assistant response to history
        _conversationHistory.add(ChatMessage(role: 'assistant', content: assistantMessage));
        debugPrint('💬 Assistant: $assistantMessage');
        return assistantMessage;
      } else {
        debugPrint('❌ Chatbot error: ${response.statusCode}');
        throw Exception('Service unavailable');
      }
    } on DioException catch (e) {
      // Remove the user message from history if request failed
      debugPrint('❌ Chatbot error: $e');
      debugPrint('❌ Chatbot error message: ${e.message}');
      if (_conversationHistory.isNotEmpty && _conversationHistory.last.role == 'user') {
        _conversationHistory.removeLast();
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('timeout');
      } else if (e.response?.statusCode == 401) {
        throw Exception('401');
      } else if (e.response?.statusCode == 429) {
        throw Exception('rate_limit');
      } else {
        throw Exception('network');
      }
    } catch (e) {
      // Remove the user message from history if request failed
      debugPrint('❌ Chatbot error here: $e');
      if (_conversationHistory.isNotEmpty && _conversationHistory.last.role == 'user') {
        _conversationHistory.removeLast();
      }
      throw Exception('error');
    }
  }
}
