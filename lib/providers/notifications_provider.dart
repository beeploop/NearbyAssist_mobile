import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/notification_model.dart';
import 'package:nearby_assist/services/notification_service.dart';

class NotificationsProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  int get unreadCount =>
      _notifications.where((notif) => !notif.isRead).toList().length;

  Future<void> fetchNotifications() async {
    try {
      final service = NotificationService();
      final notifications = await service.fetchNotifications();
      _notifications = notifications;
      notifyListeners();
    } catch (error) {
      logger.log('----- Error fetching notifications: ${error.toString()}');
      rethrow;
    }
  }

  Future<void> readNotification(NotificationModel notification) async {
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
      logger.log('----- Error reading notification: ${error.toString()}');
      rethrow;
    }
  }
}
