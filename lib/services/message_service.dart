import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/message.dart';
import 'package:http/http.dart' as http;
import 'package:nearby_assist/model/settings_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessageService extends ChangeNotifier {
  final List<Message> _messages = [];
  WebSocketChannel? _channel;

  bool isWebsocketConnected() {
    if (_channel == null) {
      return false;
    }

    return true;
  }

  void connectWebsocket() {
    final websocketAddr = getIt.get<SettingsModel>().getWebsocketAddr();
    final userId = getIt.get<AuthModel>().getUserId();

    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('$websocketAddr/v1/messages/chat?userId=$userId'),
      );

      if (_channel != null) {
        debugPrint('Connected to websocket channel');
      }
    } catch (e) {
      debugPrint('Error connecting to websocket: $e');
    }
  }

  void closeWebsocket() {
    if (_channel != null) {
      _channel!.sink.close(1000);
      _channel = null;
    }
  }

  Future<void> fetchMessages(int recipientId) async {
    final userId = getIt.get<AuthModel>().getUserId();
    final serverAddr = getIt.get<SettingsModel>().getServerAddr();

    try {
      final resp = await http.get(
        Uri.parse(
          '$serverAddr/v1/messages/conversations?from=$userId&to=$recipientId',
        ),
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

    if (_channel == null) {
      debugPrint('Cannot send message because _channel is not connected');
      return;
    }

    _channel!.sink.add(jsonEncode(message));
  }

  void addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }

  Stream<dynamic> stream() {
    return _channel!.stream;
  }
}
