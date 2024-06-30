import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/conversation.dart';
import 'package:nearby_assist/model/message.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:nearby_assist/request/dio_request.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessageService extends ChangeNotifier {
  List<Message> _messages = [];
  WebSocketChannel? _channel;

  bool isWebsocketConnected() {
    if (_channel == null) {
      return false;
    }

    return true;
  }

  void setInitialMessages(List<Message> messages) {
    _messages = messages;
    notifyListeners();
  }

  void appendMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }

  void connectWebsocket() {
    final websocketAddr = getIt.get<SettingsModel>().getWebsocketAddr();

    try {
      final tokens = getIt.get<AuthModel>().getTokens();

      _channel = WebSocketChannel.connect(
        Uri.parse('$websocketAddr/backend/chat/ws?token=${tokens.accessToken}'),
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

  Future<List<Message>> fetchMessages(int recipientId) async {
    try {
      final url = '/backend/v1/public/chat/messages/$recipientId';

      final request = DioRequest();
      final response = await request.get(url);

      _messages.clear();

      for (var message in response.data['messages']) {
        final msg = Message.fromJson(message);
        _messages.add(msg);
      }

      return _messages;
    } catch (e) {
      _messages.clear();
      debugPrint('error fetching messages: $e');

      return [];
    }
  }

  List<Message> getMessages() => _messages;

  Future<void> newMessage(String text, int toId) async {
    if (text.isEmpty) return;

    try {
      final userId = getIt.get<AuthModel>().getUserId();

      final message = Message(
        id: 0,
        sender: userId,
        receiver: toId,
        content: text,
      );

      if (_channel == null) {
        throw Exception("Websocket not connected");
      }

      _channel!.sink.add(jsonEncode(message));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Stream<dynamic> stream() {
    return _channel!.stream;
  }

  Future<List<Conversation>> fetchConversations() async {
    List<Conversation> conversations = [];

    try {
      const url = "/backend/v1/public/chat/conversations";

      final request = DioRequest();
      final response = await request.get(url);

      List data = response.data['conversations'];
      return data.map((conversation) {
        return Conversation.fromJson(conversation);
      }).toList();
    } catch (e) {
      debugPrint('error fetching conversations: $e');
      conversations.clear();
    }

    return conversations;
  }
}
