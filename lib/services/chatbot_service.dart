import 'package:dio/dio.dart';
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
      baseUrl: ApiConfig.grokApiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConfig.grokApiKey}',
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
        data: {'model': 'grok-beta', 'messages': messages, 'temperature': 0.7, 'max_tokens': 1000},
      );

      if (response.statusCode == 200) {
        final assistantMessage = response.data['choices'][0]['message']['content'] as String;

        // Add assistant response to history
        _conversationHistory.add(ChatMessage(role: 'assistant', content: assistantMessage));

        return assistantMessage;
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Connection timeout. Please check your internet connection.');
      } else if (e.response != null) {
        throw Exception('API Error: ${e.response?.statusMessage ?? 'Unknown error'}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Get a quick disease-specific response
  Future<String> getQuickDiseaseInfo(String diseaseName) async {
    final prompt =
        '''
Provide a brief summary about $diseaseName in both Urdu and English.
Include:
1. What it is (1-2 sentences)
2. Main symptoms (2-3 points)
3. Primary treatment (2-3 points)

Keep it concise and practical for farmers.
''';

    try {
      final response = await _dio.post(
        '',
        data: {
          'model': 'grok-beta',
          'messages': [
            {'role': 'system', 'content': ApiConfig.systemPrompt},
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.5,
          'max_tokens': 500,
        },
      );

      if (response.statusCode == 200) {
        return response.data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('Failed to get disease info');
      }
    } catch (e) {
      throw Exception('Failed to fetch disease information: $e');
    }
  }
}
