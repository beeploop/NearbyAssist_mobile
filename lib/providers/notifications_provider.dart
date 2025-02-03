import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/notification_model.dart';
import 'package:nearby_assist/services/notification_service.dart';

class NotificationsProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  Future<void> fetchNotifications() async {
    try {
      _isLoading = true;

      final service = NotificationService();
      final notifications = await service.fetchNotifications();
      _notifications = notifications;
      notifyListeners();
    } catch (error) {
      logger.log('----- Error fetching notifications: ${error.toString()}');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  Future<void> readNotification(String id) async {
    try {
      _isLoading = true;

      await NotificationService().markNotificationRead(id);
      _notifications.removeWhere((notification) => notification.id == id);
      notifyListeners();
    } catch (error) {
      logger.log('----- Error reading notification: ${error.toString()}');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }
}
