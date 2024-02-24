import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/message.dart';

class MessageService extends ChangeNotifier {
  final List<Message> _messages = [];

  Future<void> fetchMessages(int recipientId) async {
    debugPrint('fetching messages from server');
  }

  List<Message> getMessages() => _messages;

  Future<void> newMessage(String text, int toId) async {
    if (text.isEmpty) return;

    final userId = getIt.get<AuthModel>().getUserId();
    if (userId == null) {
      return;
    }

    final message = Message(
      fromId: userId,
      toId: toId,
      content: text,
    );

    _messages.add(message);
    notifyListeners();
  }
}

