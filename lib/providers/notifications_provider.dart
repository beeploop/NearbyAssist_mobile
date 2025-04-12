import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/notification_model.dart';
import 'package:nearby_assist/services/notification_service.dart';

class NotificationsProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  int get unreadCount =>
      _notifications.where((notif) => !notif.isRead).toList().length;

  void pushNotification(NotificationModel notif) {
    logger.logDebug('called pushNotification in notifications_provider.dart');

    _notifications.insert(0, notif);
    notifyListeners();
  }

  Future<void> fetchNotifications() async {
    logger.logDebug('called fetchNotifications in notifications_provider.dart');

    try {
      final service = NotificationService();
      final notifications = await service.fetchNotifications();
      _notifications = notifications;
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> readNotification(NotificationModel notification) async {
    logger.logDebug('called readNotification in notifications_provider.dart');

    try {
      if (notification.isRead) return;

      await NotificationService().markNotificationRead(notification.id);
      final updated = _notifications.map((n) {
        if (n.id == notification.id) {
          n.isRead = true;
        }

        return n;
      }).toList();

      _notifications = updated;
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }
}
