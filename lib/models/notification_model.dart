enum NotificationType {
  identityVerificationAccepted,
  identityVerificationRejected,
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
          case 'identity_verification_accepted':
            return NotificationType.identityVerificationAccepted;
          case 'identity_verification_rejected':
            return NotificationType.identityVerificationRejected;
          default:
            return NotificationType.generic;
        }
      }(),
    );
  }
}
