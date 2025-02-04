import 'package:flutter/material.dart';
import 'chat_service.dart';

class ChatProvider with ChangeNotifier {
  final List<Map<String, String>> _messages = [];
  final ChatService _chatService = ChatService();

  List<Map<String, String>> get messages => _messages;

  Future<void> sendMessage(String message) async {
    _messages.add({'role': 'user', 'message': message});
    notifyListeners();

    try {
      final response = await _chatService.sendMessage(message);
      _messages.add({'role': 'bot', 'message': response});
    } catch (e) {
      _messages.add({
        'role': 'bot',
        'message': 'Sorry, something went wrong. Please try again.'
      });
    }

    notifyListeners();
  }
}
