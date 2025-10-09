import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'chatbot_service.dart';

/// Service for caching chat messages locally using SharedPreferences
class ChatCacheService {
  static const String _chatHistoryKey = 'chat_history';
  static const int _maxCachedMessages = 100; // Limit to prevent excessive storage

  /// Save chat history to local storage
  static Future<void> saveChatHistory(List<ChatMessage> messages) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Take only last N messages to prevent storage bloat
      final messagesToSave = messages.length > _maxCachedMessages
          ? messages.sublist(messages.length - _maxCachedMessages)
          : messages;

      final jsonList = messagesToSave
          .map(
            (msg) => {
              'role': msg.role,
              'content': msg.content,
              'timestamp': msg.timestamp.toIso8601String(),
            },
          )
          .toList();

      await prefs.setString(_chatHistoryKey, json.encode(jsonList));
    } catch (e) {
      print('❌ Error saving chat history: $e');
    }
  }

  /// Load chat history from local storage
  static Future<List<ChatMessage>> loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_chatHistoryKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map(
            (json) => ChatMessage(
              role: json['role'] as String,
              content: json['content'] as String,
              timestamp: DateTime.parse(json['timestamp'] as String),
            ),
          )
          .toList();
    } catch (e) {
      print('❌ Error loading chat history: $e');
      return [];
    }
  }

  /// Clear all chat history from local storage
  static Future<void> clearChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_chatHistoryKey);
    } catch (e) {
      print('❌ Error clearing chat history: $e');
    }
  }

  /// Save specific disease context for chat continuation
  static Future<void> saveDiseaseContext(String diseaseName, String description) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_disease_name', diseaseName);
      await prefs.setString('last_disease_description', description);
    } catch (e) {
      print('❌ Error saving disease context: $e');
    }
  }

  /// Load last disease context
  static Future<Map<String, String>?> loadDiseaseContext() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final diseaseName = prefs.getString('last_disease_name');
      final diseaseDescription = prefs.getString('last_disease_description');

      if (diseaseName != null && diseaseDescription != null) {
        return {'name': diseaseName, 'description': diseaseDescription};
      }
      return null;
    } catch (e) {
      print('❌ Error loading disease context: $e');
      return null;
    }
  }

  /// Clear disease context
  static Future<void> clearDiseaseContext() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('last_disease_name');
      await prefs.remove('last_disease_description');
    } catch (e) {
      print('❌ Error clearing disease context: $e');
    }
  }

  /// Check if there's cached chat history
  static Future<bool> hasCachedHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_chatHistoryKey);
    } catch (e) {
      return false;
    }
  }

  /// Get the number of cached messages
  static Future<int> getCachedMessageCount() async {
    try {
      final messages = await loadChatHistory();
      return messages.length;
    } catch (e) {
      return 0;
    }
  }

  /// Save a single message (append to existing history)
  static Future<void> saveMessage(ChatMessage message) async {
    try {
      final history = await loadChatHistory();
      history.add(message);
      await saveChatHistory(history);
    } catch (e) {
      print('❌ Error saving message: $e');
    }
  }

  /// Get chat statistics
  static Future<Map<String, dynamic>> getChatStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = await loadChatHistory();

      final userMessages = history.where((msg) => msg.role == 'user').length;
      final assistantMessages = history.where((msg) => msg.role == 'assistant').length;
      final lastChatTime = history.isNotEmpty ? history.last.timestamp : null;

      return {
        'total_messages': history.length,
        'user_messages': userMessages,
        'assistant_messages': assistantMessages,
        'last_chat_time': lastChatTime?.toIso8601String(),
        'has_disease_context': prefs.containsKey('last_disease_name'),
      };
    } catch (e) {
      print('❌ Error getting chat stats: $e');
      return {};
    }
  }
}
