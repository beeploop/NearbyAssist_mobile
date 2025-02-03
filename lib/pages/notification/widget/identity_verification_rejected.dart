import 'package:flutter/material.dart';
import 'package:nearby_assist/models/notification_model.dart';

class IdentityVerificationRejected extends StatelessWidget {
  const IdentityVerificationRejected({
    super.key,
    required this.notification,
  });

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            // title
            Text(
              notification.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),

            // content
            Text(notification.content),
          ],
        ),
      ),
    );
  }
}
