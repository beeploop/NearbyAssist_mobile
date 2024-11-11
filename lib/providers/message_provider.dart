import 'dart:math';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/conversation_model.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/services/secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessageProvider extends ChangeNotifier {
  WebSocketChannel? _channel;
  bool _connected = false;

  bool get connected => _connected;

  List<ConversationModel> _conversations = [];
  final Map<String, List<types.Message>> _messages = {};

  List<ConversationModel> get conversations => _conversations;

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
      (event) => logger.log,
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
}
