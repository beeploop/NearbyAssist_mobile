import 'dart:convert';
import 'package:diffie_hellman/diffie_hellman.dart';
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
  final Map<String, DhPublicKey> _publicKeyCache = {};

  bool isWebsocketConnected() {
    if (_channel == null) {
      return false;
    }

    return true;
  }

  void closeWebsocket() {
    if (_channel != null) {
      _channel!.sink.close(1000);
      _channel = null;
    }
  }

  Stream<dynamic> stream() {
    return _channel!.stream;
  }

  void connectWebsocket() {
    try {
      final websocketAddr = getIt.get<SettingsModel>().getWebsocketAddr();
      final tokens = getIt.get<AuthModel>().getTokens();

      _channel = WebSocketChannel.connect(
        Uri.parse('$websocketAddr/api/v1/chat/ws?token=${tokens.accessToken}'),
      );

      if (_channel != null) {
        debugPrint('Connected to websocket channel');
      }
    } catch (e) {
      debugPrint('Error connecting to websocket: $e');
      rethrow;
    }
  }

  void setInitialMessages(List<Message> messages) {
    _messages = messages;
    notifyListeners();
  }

  Future<void> appendMessage(Message? message, String otherUser) async {
    if (message == null) {
      return;
    }

    final decrypted = await _decryptMessage(message.content, otherUser);

    _messages.add(Message(
      id: message.id,
      sender: message.sender,
      receiver: message.receiver,
      content: decrypted,
    ));
    notifyListeners();
  }

  Future<List<Message>> fetchMessages(String recipientId) async {
    try {
      final url = '/api/v1/chat/messages/$recipientId';
      final request = DioRequest();
      final response = await request.get(url);

      final messages = response.data["messages"];
      if (messages == null) {
        return [];
      }

      final messageList = (messages as List).map((message) {
        return Message.fromJson(message);
      }).toList();

      // decrypt messages
      for (var i = 0; i < messageList.length; i++) {
        final decrypted = await _decryptMessage(
          messageList[i].content,
          recipientId,
        );
        messageList[i].content = decrypted;
      }

      return messageList;
    } catch (e) {
      debugPrint('error fetching messages: $e');
      rethrow;
    }
  }

  List<Message> getMessages() => _messages;

  Future<void> newMessage(String text, String toId) async {
    if (text.isEmpty) return;

    try {
      final userId = getIt.get<AuthModel>().getUserId();
      final encrypted = await _encryptMessage(text, toId);

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

  Future<String> _decryptMessage(String message, String otherUserId) async {
    try {
      final dh = DiffieHellman();
      DhPublicKey? publicKey;

      if (!_publicKeyCache.containsKey(otherUserId)) {
        if (kDebugMode) {
          print("Public key cache miss");
        }
        publicKey = await dh.getPublicKey(otherUserId);
        _publicKeyCache[otherUserId] = publicKey;
      } else {
        if (kDebugMode) {
          print("Public key cache hit");
        }
        publicKey = _publicKeyCache[otherUserId]!;
      }

      final sharedSecret = await dh.computeSharedSecret(publicKey);

      final aes = Encryption.fromBigInt(sharedSecret);
      return aes.decrypt(message);
    } catch (err) {
      rethrow;
    }
  }

  Future<String> _encryptMessage(String message, String otherUserId) async {
    try {
      final dh = DiffieHellman();
      DhPublicKey? publicKey;

      if (!_publicKeyCache.containsKey(otherUserId)) {
        if (kDebugMode) {
          print("Public key cache miss");
        }
        publicKey = await dh.getPublicKey(otherUserId);
        _publicKeyCache[otherUserId] = publicKey;
      } else {
        if (kDebugMode) {
          print("Public key cache hit");
        }
        publicKey = _publicKeyCache[otherUserId]!;
      }

      final sharedSecret = await dh.computeSharedSecret(publicKey);

      final aes = Encryption.fromBigInt(sharedSecret);
      return aes.encrypt(message);
    } catch (err) {
      rethrow;
    }
  }
}
