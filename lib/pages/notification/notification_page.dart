import 'package:flutter/material.dart';
import 'package:nearby_assist/models/notification_model.dart';
import 'package:nearby_assist/pages/notification/widget/generic_notification.dart';
import 'package:nearby_assist/pages/notification/widget/identity_verification_accepted.dart';
import 'package:nearby_assist/pages/notification/widget/identity_verification_rejected.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, required this.notification});

  final NotificationModel notification;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    switch (widget.notification.type) {
      case NotificationType.identityVerificationAccepted:
        return IdentityVerificationAccepted(
          notification: widget.notification,
        );
      case NotificationType.identityVerificationRejected:
        return IdentityVerificationRejected(
          notification: widget.notification,
        );
      case NotificationType.generic:
        return GenericNotification(
          notification: widget.notification,
        );
    }
  }
}
