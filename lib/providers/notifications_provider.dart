import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/notification_model.dart';
import 'package:nearby_assist/services/notification_service.dart';

class NotificationsProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

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

  Future<void> readNotification(String id) async {
    try {
      await NotificationService().markNotificationRead(id);
      _notifications.removeWhere((notification) => notification.id == id);
      notifyListeners();
    } catch (error) {
      logger.log('----- Error reading notification: ${error.toString()}');
      rethrow;
    }
  }
}
