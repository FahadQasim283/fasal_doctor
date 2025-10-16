import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/chatbot_service.dart';

class ChatStorageService {
  static const String _chatHistoryKey = 'chat_history';
  static const String _diseaseContextKey = 'disease_context';

  static final ChatStorageService _instance = ChatStorageService._internal();
  factory ChatStorageService() => _instance;
  ChatStorageService._internal();

  /// Save chat history to local storage
  Future<void> saveChatHistory(List<ChatMessage> messages) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final chatData = messages
          .map(
            (msg) => {
              'role': msg.role,
              'content': msg.content,
              'timestamp': msg.timestamp.toIso8601String(),
            },
          )
          .toList();

      final jsonString = jsonEncode(chatData);
      await prefs.setString(_chatHistoryKey, jsonString);
    } catch (e) {
      print('Error saving chat history: $e');
    }
  }

  /// Load chat history from local storage
  Future<List<ChatMessage>> loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_chatHistoryKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final chatData = jsonDecode(jsonString) as List<dynamic>;
      return chatData
          .map(
            (data) => ChatMessage(
              role: data['role'] as String,
              content: data['content'] as String,
              timestamp: DateTime.parse(data['timestamp'] as String),
            ),
          )
          .toList();
    } catch (e) {
      print('Error loading chat history: $e');
      return [];
    }
  }

  /// Save disease context information
  Future<void> saveDiseaseContext(String? diseaseName, String? diseaseDescription) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (diseaseName != null && diseaseDescription != null) {
        final contextData = {'diseaseName': diseaseName, 'diseaseDescription': diseaseDescription};
        await prefs.setString(_diseaseContextKey, jsonEncode(contextData));
      } else {
        await prefs.remove(_diseaseContextKey);
      }
    } catch (e) {
      print('Error saving disease context: $e');
    }
  }

  /// Load disease context information
  Future<Map<String, String>?> loadDiseaseContext() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_diseaseContextKey);

      if (jsonString == null || jsonString.isEmpty) {
        return null;
      }

      final contextData = jsonDecode(jsonString) as Map<String, dynamic>;
      return {
        'diseaseName': contextData['diseaseName'] as String,
        'diseaseDescription': contextData['diseaseDescription'] as String,
      };
    } catch (e) {
      print('Error loading disease context: $e');
      return null;
    }
  }

  /// Clear all stored chat data
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_chatHistoryKey);
      await prefs.remove(_diseaseContextKey);
    } catch (e) {
      print('Error clearing chat data: $e');
    }
  }

  /// Check if there's any stored chat data
  Future<bool> hasStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_chatHistoryKey) || prefs.containsKey(_diseaseContextKey);
    } catch (e) {
      return false;
    }
  }
}
