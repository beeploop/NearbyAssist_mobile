import 'package:flutter/material.dart';
import 'package:nearby_assist/models/notification_model.dart';
import 'package:nearby_assist/pages/notification/widget/identity_verification_accepted.dart';
import 'package:nearby_assist/pages/notification/widget/identity_verification_request_response.dart';

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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.notification.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
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
        return IdentityVerificationRequestResponse(
          notification: widget.notification,
        );
      case NotificationType.generic:
        return IdentityVerificationRequestResponse(
          notification: widget.notification,
        );
    }
  }
}
