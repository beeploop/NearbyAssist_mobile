import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/events.dart';
import 'package:nearby_assist/models/notification_model.dart';
import 'package:nearby_assist/models/received_message_model.dart';
import 'package:nearby_assist/providers/client_booking_provider.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
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
  final _pingInterval = const Duration(seconds: 15);
  final _pongTimeout = const Duration(seconds: 30);
  WebSocketChannel? _channel;
  WebsocketStatus _status = WebsocketStatus.disconnected;
  MessageProvider? _messageProvider;
  NotificationsProvider? _notifProvider;
  UserProvider? _userProvider;
  ClientBookingProvider? _clientBookingProvider;
  ControlCenterProvider? _controlCenterProvider;

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

  void setClientBookingProvider(ClientBookingProvider provider) {
    _clientBookingProvider = provider;
  }

  void setControlCenterProvider(ControlCenterProvider provider) {
    _controlCenterProvider = provider;
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
    // logger.logDebug('received pong');
    _pongTimeoutTimer?.cancel();
    _pongTimeoutTimer = null;
  }

  void _processEvent(dynamic event) {
    try {
      final result = EventHandler().process(event);
      switch (result.event) {
        case Event.pong:
          _receivePong();

        case Event.message:
          final payload = ReceivedMessageModel.fromJson(result.data['payload']);
          _messageProvider?.receive(payload);

        case Event.notification:
          final payload = NotificationModel.fromJson(result.data['payload']);
          _notifProvider?.pushNotification(payload);

        case Event.sync:
          _userProvider?.syncAccount();

        case Event.bookingComplete:
          final bookingId = result.data['payload'];
          _clientBookingProvider?.bookingCompleted(bookingId);

        case Event.bookingConfirmed:
          final bookingId = result.data['payload']['id'];
          final scheduleStart = result.data['payload']['scheduleStart'];
          final scheduleEnd = result.data['payload']['scheduleEnd'];

          _clientBookingProvider?.bookingConfirmed(
            bookingId,
            scheduleStart,
            scheduleEnd,
          );

        case Event.bookingRescheduled:
          final bookingId = result.data['payload']['id'];
          final scheduleStart = result.data['payload']['scheduleStart'];
          final scheduleEnd = result.data['payload']['scheduleEnd'];

          _clientBookingProvider?.bookingRescheduled(
            bookingId,
            scheduleStart,
            scheduleEnd,
          );

        case Event.bookingRejected:
          final bookingId = result.data['payload']['id'];
          final reason = result.data['payload']['reason'];
          _clientBookingProvider?.bookingRejected(bookingId, reason);

        case Event.vendorCancelledBooking:
          final bookingId = result.data['payload']['id'];
          final reason = result.data['payload']['reason'];
          _clientBookingProvider?.bookingCancelled(bookingId, reason);

        case Event.receivedBooking:
          final booking = BookingModel.fromJson(result.data['payload']);
          _controlCenterProvider?.receivedRequest(booking);

        case Event.clientCancelledBooking:
          final bookingId = result.data['payload']['id'];
          final reason = result.data['payload']['reason'];
          _controlCenterProvider?.cancelledRequest(bookingId, reason);

        case Event.unknown:
          throw 'unknown event type';
      }
    } catch (error) {
      logger.logError(error.toString());
    }
  }
}
