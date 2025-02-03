import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/notification_model.dart';
import 'package:nearby_assist/services/api_service.dart';

class NotificationService {
  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.getNotifications);

      return (response.data['notifications'] as List)
          .map((notification) => NotificationModel.fromJson(notification))
          .toList();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> markNotificationRead(String notificationId) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.post('${endpoint.readNotification}/$notificationId');
    } catch (error) {
      rethrow;
    }
  }
}
