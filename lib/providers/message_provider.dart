import 'dart:convert';
import 'package:diffie_hellman/diffie_hellman.dart';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/conversation_model.dart';
import 'package:nearby_assist/models/message_model.dart';
import 'package:nearby_assist/models/text_message_model.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/services/diffie_hellman.dart';
import 'package:nearby_assist/services/encryption.dart';
import 'package:nearby_assist/services/secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessageProvider extends ChangeNotifier {
  final Map<String, DhPublicKey> _publicKeyCache = {};

  WebSocketChannel? _channel;
  bool _connected = false;

  bool get connected => _connected;

  List<ConversationModel> _conversations = [];
  final Map<String, List<TextMessageModel>> _messages = {};

  List<ConversationModel> get conversations => _conversations;

  List<types.Message> getMessages(String recipientId) {
    if (_messages.containsKey(recipientId)) {
      return _messages[recipientId]!
          .map((message) => types.TextMessage(
                id: message.id,
                author: message.author,
                text: message.text,
                status: message.status,
                showStatus: message.showStatus,
              ))
          .toList();
    }

    return [];
  }

  void send(MessageModel message) async {
    // This is not a bug, its a feature. I promise.
    if (_isSpam(message)) {
      return;
    }

    if (_channel == null) return;

    if (_messages.containsKey(message.receiver)) {
      _messages[message.receiver]!.insert(0, message.toTextMessage());
    } else {
      _messages[message.receiver] = [];
      _messages[message.receiver]!.insert(0, message.toTextMessage());
    }

    notifyListeners();

    final encrypted = await _encrypt(message);

    try {
      final api = ApiService.authenticated();
      await api.dio.post(endpoint.sendMessage, data: encrypted.toJson());
    } catch (error) {
      logger.log('Error sending message: ${error.toString()}');
    }
  }

  void receive(MessageModel message) async {
    final decrypted = await _decrypt(message);

    _updateMessageStatus(decrypted);
    _updateConversations(decrypted);

    notifyListeners();
  }

  Future<void> fetchConversations() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.conversations);

      final conversations = (response.data['conversations'] as List)
          .map((conversation) => ConversationModel.fromJson(conversation))
          .toList();

      _conversations = conversations;
      notifyListeners();
    } catch (error) {
      logger.log('Error fetching conversations: $error');
    }
  }

  Future<void> connect() async {
    logger.log('Connecting to websocket');

    final store = SecureStorage();
    final accessToken = await store.getToken(TokenType.accessToken);
    if (accessToken == null) {
      throw 'NoToken';
    }

    final url = '${endpoint.websocket}?token=$accessToken';
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _connected = true;
    notifyListeners();

    _channel!.stream.listen(
      (event) {
        try {
          final message = MessageModel.fromJson(jsonDecode(event));
          receive(message);
        } catch (error) {
          logger.log('Malformed message: ${error.toString()}');
        }
      },
      onDone: disconnect,
      onError: (error) {
        logger.log('Error connecting to websocket: $error');
      },
      cancelOnError: true,
    );
  }

  void disconnect() {
    if (_channel == null) return;

    _channel!.sink.close(1000);
    _channel = null;
    _connected = false;

    logger.log('Disconnected from websocket');
  }

  Future<MessageModel> _encrypt(MessageModel message) async {
    try {
      final dh = DiffieHellman();
      DhPublicKey? publicKey;

      if (!_publicKeyCache.containsKey(message.receiver)) {
        logger.log("Public key cache miss");
        publicKey = await dh.getPublicKey(message.receiver);
        _publicKeyCache[message.receiver] = publicKey;
      } else {
        logger.log("Public key cache hit");
        publicKey = _publicKeyCache[message.receiver]!;
      }

      final sharedSecret = await dh.computeSharedSecret(publicKey);

      final aes = Encryption.fromBigInt(sharedSecret);
      final encrypted = aes.encrypt(message.content);

      return message.copyWithNewContent(encrypted);
    } catch (err) {
      rethrow;
    }
  }

  Future<MessageModel> _decrypt(MessageModel message) async {
    try {
      final dh = DiffieHellman();
      DhPublicKey? publicKey;

      if (!_publicKeyCache.containsKey(message.receiver)) {
        logger.log("Public key cache miss");
        publicKey = await dh.getPublicKey(message.receiver);
        _publicKeyCache[message.receiver] = publicKey;
      } else {
        logger.log("Public key cache hit");
        publicKey = _publicKeyCache[message.receiver]!;
      }

      final sharedSecret = await dh.computeSharedSecret(publicKey);

      final aes = Encryption.fromBigInt(sharedSecret);
      final decrypted = aes.decrypt(message.content);

      return message.copyWithNewContent(decrypted);
    } catch (err) {
      rethrow;
    }
  }

  void _updateConversations(MessageModel message) {
    for (var conversation in _conversations) {
      if (conversation.recipientId == message.receiver) {
        conversation.lastMessage = message.content;
        conversation.date = DateTime.now().toIso8601String();
        return;
      }
    }
  }

  void _updateMessageStatus(MessageModel fromEvent) {
    // If new conversation, not initiated by user
    if (!_messages.containsKey(fromEvent.receiver)) {
      _messages[fromEvent.receiver] = [];
      _messages[fromEvent.receiver]!.insert(
        0,
        fromEvent.toTextMessage(status: types.Status.sent),
      );

      return;
    }

    // TODO: Implement a better solution of updating the status of the message
    // This is highly unsafe operation.
    // Crashes the app when user send a message while the previous message is still sending.
    // Temporary fix is to allow only one message to be sent at a time.
    // isSpam() function is used to check if the previous message is still sending.
    _messages[fromEvent.receiver]!.removeAt(0);
    _messages[fromEvent.receiver]!.insert(
        0,
        TextMessageModel(
          id: fromEvent.id,
          author: types.User(id: fromEvent.sender),
          text: fromEvent.content,
          status: types.Status.sent,
          showStatus: true,
        ));
  }

  bool _isSpam(MessageModel message) {
    if (_messages[message.receiver] == null) return false;

    final prev = _messages[message.receiver]![0];
    logger.log(prev.status);
    if (prev.status == types.Status.sending) {
      return true;
    }

    return false;
  }
}
