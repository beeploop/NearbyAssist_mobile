import 'package:flutter/material.dart';
import 'package:nearby_assist/models/notification_model.dart';

class IdentityVerificationRequestResponse extends StatelessWidget {
  const IdentityVerificationRequestResponse({
    super.key,
    required this.notification,
  });

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // title
          Text(notification.title),
          const SizedBox(height: 20),

          // content
          Text(notification.content),
        ],
      ),
    );
  }
}
