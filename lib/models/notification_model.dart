enum NotificationType {
  success,
  fail,
  announcement,
  generic,
}

class NotificationModel {
  final String id;
  final String recipient;
  final NotificationType type;
  final String title;
  final String content;

  NotificationModel({
    required this.id,
    required this.recipient,
    required this.type,
    required this.title,
    required this.content,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      recipient: json['recipient'],
      title: json['title'],
      content: json['content'],
      type: () {
        switch (json['type'] as String) {
          case 'success':
            return NotificationType.success;
          case 'fail':
            return NotificationType.fail;
          case 'announcement':
            return NotificationType.announcement;
          case 'generic':
            return NotificationType.generic;
          default:
            return NotificationType.generic;
        }
      }(),
    );
  }
}
