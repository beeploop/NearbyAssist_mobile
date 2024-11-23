import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/message_model.dart';
import 'package:nearby_assist/providers/message_provider.dart';
import 'package:nearby_assist/services/secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum WebsocketStatus { connected, disconnected, connecting }

class WebsocketProvider extends ChangeNotifier {
  MessageProvider? _messageProvider;
  WebSocketChannel? _channel;
  WebsocketStatus _status = WebsocketStatus.disconnected;

  WebsocketStatus get status => _status;

  void setMessageProvider(MessageProvider messageProvider) {
    _messageProvider = messageProvider;
  }

  Future<void> connect() async {
    if (_channel != null ||
        _status == WebsocketStatus.connected ||
        _status == WebsocketStatus.connecting) return;

    _status = WebsocketStatus.connecting;
    notifyListeners();

    final accessToken = await SecureStorage().getToken(TokenType.accessToken);
    if (accessToken == null) {
      _status = WebsocketStatus.disconnected;
      notifyListeners();
      return Future.error('NoToken');
    }

    final url = '${endpoint.websocket}?token=$accessToken';
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _status = WebsocketStatus.connected;
    notifyListeners();

    _channel!.stream.listen(
      (event) {
        try {
          final decoded = jsonDecode(event);
          final message = MessageModel.fromJson(decoded);
          _receiveMessage(message);
        } catch (error) {
          logger.log('Error parsing event: ${error.toString()}');
        }
      },
      onDone: disconnect,
      onError: (error) => logger.log,
      cancelOnError: true,
    );
  }

  void disconnect() {
    if (_channel == null) return;

    _channel!.sink.close(1000);
    _channel = null;
    _status = WebsocketStatus.disconnected;
  }

  Future<void> _receiveMessage(MessageModel message) async {
    if (_messageProvider == null) {
      logger.log('--- message provider is null');
      return;
    }

    _messageProvider!.receive(message);
  }
}
