import 'dart:math';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/conversation_model.dart';
import 'package:nearby_assist/services/api_service.dart';

class MessageProvider extends ChangeNotifier {
  List<ConversationModel> _conversations = [];
  final Map<String, List<types.Message>> _messages = {};

  List<ConversationModel> get conversations => _conversations;

  List<types.Message> getMessages(String recipientId) {
    if (_messages.containsKey(recipientId)) {
      return _messages[recipientId]!;
    }

    return [];
  }

  void newMessage(String recipientId, types.Message message) {
    if (_messages.containsKey(recipientId)) {
      _messages[recipientId]!.insert(0, message);
      notifyListeners();
    } else {
      _messages[recipientId] = [];
      _messages[recipientId]!.insert(0, message);

      notifyListeners();
    }

    // Imitate message status behavior
    Future.delayed(const Duration(seconds: 2), () {
      _messages[recipientId]!.remove(message);

      final newMessage = message.copyWith(
        status:
            Random().nextInt(2) == 0 ? types.Status.sent : types.Status.error,
      );
      _messages[recipientId]!.insert(0, newMessage);

      notifyListeners();
    });
  }

  Future<void> fetchConversations() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.conversations);
      logger.log(response.data['conversations']);

      final conversations = (response.data['conversations'] as List)
          .map((conversation) => ConversationModel.fromJson(conversation))
          .toList();

      _conversations = conversations;
      notifyListeners();
    } catch (error) {
      logger.log('Error fetching conversations: $error');
    }
  }
}
