import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/conversation.dart';
import 'package:nearby_assist/model/message.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:nearby_assist/request/dio_request.dart';
import 'package:nearby_assist/services/diffie_hellman.dart';
import 'package:nearby_assist/services/encryption.dart';
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

  Future<void> appendMessage(Message message, String otherUser) async {
    final dh = DiffieHellman();
    final otherUserPublicKey = await dh.getPublicKey(otherUser);
    final sharedSecret = await dh.computeSharedSecret(otherUserPublicKey);

    final aes = Encryption.fromBigInt(sharedSecret);
    final decrypted = aes.decrypt(message.content);

    _messages.add(Message(
      id: message.id,
      sender: message.sender,
      receiver: message.receiver,
      content: decrypted,
    ));
    notifyListeners();
  }

  void connectWebsocket() {
    final websocketAddr = getIt.get<SettingsModel>().getWebsocketAddr();

    try {
      final tokens = getIt.get<AuthModel>().getTokens();

      _channel = WebSocketChannel.connect(
        Uri.parse('$websocketAddr/chat/ws?token=${tokens.accessToken}'),
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

  Future<List<Message>> fetchMessages(String recipientId) async {
    try {
      final url = '/v1/public/chat/messages/$recipientId';

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

  Future<void> newMessage(String text, String toId) async {
    if (text.isEmpty) return;

    try {
      final userId = getIt.get<AuthModel>().getUserId();
      final dh = DiffieHellman();
      final recipientPublicKey = await dh.getPublicKey(toId);
      final sharedSecret = await dh.computeSharedSecret(recipientPublicKey);

      final aes = Encryption.fromBigInt(sharedSecret);
      final encrypted = aes.encrypt(text);

      final message = Message(
        id: "0",
        sender: userId,
        receiver: toId,
        content: encrypted,
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
    try {
      const url = "/api/v1/chat/conversations";

      final request = DioRequest();
      final response = await request.get(url);

      final conversations = response.data['conversations'];
      if (conversations == null) {
        return [];
      }

      final conversationList = conversations as List;
      return conversationList.map((conversation) {
        return Conversation.fromJson(conversation);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}
