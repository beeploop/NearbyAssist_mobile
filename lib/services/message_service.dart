import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/conversation.dart';
import 'package:nearby_assist/model/message.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:nearby_assist/services/request/authenticated_request.dart';
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

    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('$websocketAddr/backend/v1/public/chat/ws'),
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
    try {
      final tokens = getIt.get<AuthModel>().getUserTokens();
      if (tokens == null) {
        throw Exception('error retrieving user token');
      }

      final endpoint = '/backend/v1/public/chat/messages/$recipientId';
      final request = AuthenticatedRequest<Map<String, dynamic>>();
      final response = await request.request(endpoint, "GET");

      _messages.clear();

      for (var message in response['messages']) {
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

  Future<List<Conversation>> fetchConversations() async {
    List<Conversation> conversations = [];

    try {
      final tokens = getIt.get<AuthModel>().getUserTokens();
      if (tokens == null) {
        throw Exception('error retrieving user token');
      }

      final request = AuthenticatedRequest<Map<String, dynamic>>();

      final response = await request.request(
        '/backend/v1/public/chat/conversations',
        "GET",
      );

      for (var conversation in response['conversations']) {
        final conv = Conversation.fromJson(conversation);
        conversations.add(conv);
      }
    } catch (e) {
      debugPrint('error fetching conversations: $e');
      conversations.clear();
    }

    return conversations;
  }
}
