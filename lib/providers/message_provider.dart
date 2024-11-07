import 'dart:math';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class MessageProvider extends ChangeNotifier {
  final Map<String, List<types.Message>> _messages = {};

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
}
