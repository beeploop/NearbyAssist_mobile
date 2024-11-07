import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/conversation_model.dart';

class InboxProvider extends ChangeNotifier {
  final List<ConversationModel> _conversations = [];

  List<ConversationModel> get conversations => _conversations;

  void add(ConversationModel conversation) {
    _conversations.add(conversation);
    notifyListeners();
  }

  void updateConversation(String recipientId, String message, String date) {
    for (var conversation in _conversations) {
      if (conversation.recipientId == recipientId) {
        conversation.lastMessage = message;
        conversation.date = date;
      }
    }

    notifyListeners();
  }

  bool includes(String recipientId) {
    for (int i = 0; i < _conversations.length; i++) {
      if (_conversations[i].recipientId == recipientId) {
        return true;
      }
    }
    return false;
  }
}
