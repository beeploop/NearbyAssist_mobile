import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/message_model.dart';
import 'package:nearby_assist/models/notification_model.dart';
import 'package:nearby_assist/providers/message_provider.dart';
import 'package:nearby_assist/providers/notifications_provider.dart';
import 'package:nearby_assist/providers/token_change_notifier.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum WebsocketStatus { connected, disconnected, connecting }

enum EventType { message, notification, sync }

class WebsocketProvider extends ChangeNotifier {
  Timer? _pingTimer;
  Timer? _pongTimeoutTimer;
  final _pingInterval = const Duration(seconds: 30);
  final _pongTimeout = const Duration(seconds: 10);
  MessageProvider? _messageProvider;
  NotificationsProvider? _notifProvider;
  UserProvider? _userProvider;
  WebSocketChannel? _channel;
  WebsocketStatus _status = WebsocketStatus.disconnected;

  WebsocketStatus get status => _status;

  void setMessageProvider(MessageProvider messageProvider) {
    _messageProvider = messageProvider;
  }

  void setNotifProvider(NotificationsProvider notifProvider) {
    _notifProvider = notifProvider;
  }

  void setUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;
  }

  void init() {
    TokenChangeNotifier().addListener(_onTokenRefreshed);
  }

  Future<void> _onTokenRefreshed() async {
    logger.logDebug('token refreshed, triggering websocket reconnect');
    await _reconnect();
  }

  @override
  void dispose() {
    TokenChangeNotifier().removeListener(_onTokenRefreshed);
    super.dispose();
  }

  Future<void> connect() async {
    logger.logDebug('called connect in websocket_provider.dart');

    try {
      if (_channel != null || _status != WebsocketStatus.disconnected) return;
      logger.logDebug('continued calling connect');

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
      logger.logDebug('wesocket connected');
      notifyListeners();

      _startPinging();

      _channel!.stream.listen(
        _processEvent,
        onDone: disconnect,
        onError: (error) => logger.logError,
        cancelOnError: true,
      );
    } on WebSocketChannelException catch (error) {
      logger.logError(error.toString());
    } catch (error) {
      logger.logError('generic error: ${error.toString()}');
    }
  }

  Future<void> _reconnect() async {
    logger.logDebug('trying to reconnect websocket');
    disconnect();
    await connect();
  }

  void disconnect() {
    logger.logDebug('called disconnect in websocket_provider.dart');

    if (_channel == null) return;

    _channel!.sink.close(1000);
    _channel = null;
    _status = WebsocketStatus.disconnected;

    notifyListeners();

    _stopPinging();
  }

  void _startPinging() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(_pingInterval, (_) {
      if (_channel == null) return;
      _channel!.sink.add("ping");
      logger.logDebug('sent ping message');
      _startPongTimeout();
    });
  }

  void _stopPinging() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  void _startPongTimeout() {
    _pongTimeoutTimer?.cancel();
    _pongTimeoutTimer = Timer.periodic(_pongTimeout, (_) {
      logger.logDebug('did not recieve pong in time, reconnecting ws...');
      _reconnect();
    });
  }

  void _receivePong() {
    logger.logDebug('received pong message');
    _pongTimeoutTimer?.cancel();
    _pongTimeoutTimer = null;
  }

  void _processEvent(dynamic event) {
    try {
      logger.logDebug('processing received event');

      if (event == "pong") {
        _receivePong();
        return;
      }

      final decoded = jsonDecode(event);
      switch (decoded['type']) {
        case 'message':
          final payload = MessageModel.fromJson(decoded['payload']);
          _receiveMessage(payload);
        case 'notification':
          final payload = NotificationModel.fromJson(decoded['payload']);
          _pushNotif(payload);
        case 'sync':
          _syncUser();
        default:
          throw 'unknown event type';
      }
    } catch (error) {
      logger.logError(error.toString());
    }
  }

  Future<void> _receiveMessage(MessageModel message) async {
    if (_messageProvider == null) {
      throw 'message provider is null';
    }

    _messageProvider!.receive(message);
  }

  void _pushNotif(NotificationModel notif) {
    if (_notifProvider == null) {
      throw 'notification provider is null';
    }

    _notifProvider!.pushNotification(notif);
  }

  void _syncUser() {
    if (_userProvider == null) {
      throw 'user provider is null';
    }

    _userProvider!.syncAccount();
  }
}
