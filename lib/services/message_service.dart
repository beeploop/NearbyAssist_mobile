import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/message.dart';
import 'package:http/http.dart' as http;

class MessageService extends ChangeNotifier {
  final List<Message> _messages = [];

  Future<void> fetchMessages(int recipientId) async {
    final userId = getIt.get<AuthModel>().getUserId();
    try {
      final resp = await http.get(
        Uri.parse(
            '$backendServer/v1/messages/conversations?from=$userId&to=$recipientId'),
      );

      _messages.clear();

      List messages = jsonDecode(resp.body);
      for (var message in messages) {
        final msg = Message.fromJson(message);
        _messages.add(msg);
      }
    } catch (e) {
      _messages.clear();
      debugPrint('error fetching messages: $e');
    }

    notifyListeners();
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
