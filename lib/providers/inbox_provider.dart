import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/conversation_model.dart';

class InboxProvider extends ChangeNotifier {
  final List<ConversationModel> _conversations = [];

  List<ConversationModel> get conversations => _conversations;

  void add(ConversationModel conversation) {
    _conversations.add(conversation);
    notifyListeners();
  }
}
