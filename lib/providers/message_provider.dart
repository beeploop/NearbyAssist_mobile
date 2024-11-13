import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/conversation_model.dart';
import 'package:nearby_assist/models/message_model.dart';
import 'package:nearby_assist/models/partial_message_model.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class MessageProvider extends ChangeNotifier {
  final List<ConversationModel> _conversations = [];
  final Map<String, List<MessageModel>> _messages = {};

  List<ConversationModel> getConversations() => _conversations;

  Future<List<types.TextMessage>> getMessages(String recipientId) async {
    if (_messages.containsKey(recipientId)) {
      return _messages[recipientId]!.map((e) => e.toTextMessage()).toList();
    }

    throw Exception('NotFound');
  }

  Future<void> refreshConversations() async {
    return Future.error('Unimplemented');
  }

  Future<void> send(PartialMessageModel message) async {
    return Future.error('Unimplemented');
  }

  void addMessage(MessageModel message) {
    if (_messages.containsKey(message.receiver)) {
      _messages[message.receiver]!.insert(0, message);
    } else {
      _messages[message.receiver] = [];
      _messages[message.receiver]!.insert(0, message);
    }

    notifyListeners();
  }
}
