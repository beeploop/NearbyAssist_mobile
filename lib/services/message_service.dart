import 'package:flutter/material.dart';
import 'package:nearby_assist/model/message.dart';

class MessageService extends ChangeNotifier {
  final List<Message> _messages = [];

  List<Message> getMessages() => _messages;

  void newMessage(String text) {
    if (text.isEmpty) return;

    final message = Message(
      fromId: 1,
      toId: 1,
      content: text,
    );

    _messages.add(message);
    notifyListeners();
  }
}

