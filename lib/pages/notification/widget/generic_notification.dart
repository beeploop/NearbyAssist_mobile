import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/config/theme/app_colors.dart';
import 'package:nearby_assist/models/notification_model.dart';

class GenericNotification extends StatelessWidget {
  const GenericNotification({
    super.key,
    required this.notification,
  });

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            // Icon
            _buildIcon(),
            const SizedBox(height: 20),

            // Title
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

  Widget _buildIcon() {
    late IconData icon;
    switch (notification.type) {
      case NotificationType.success:
        icon = CupertinoIcons.checkmark_circle_fill;
        break;
      case NotificationType.fail:
        icon = CupertinoIcons.clear_circled_solid;
        break;
      case NotificationType.announcement:
        icon = CupertinoIcons.gift_fill;
        break;
      case NotificationType.generic:
        icon = CupertinoIcons.bell_fill;
        break;
      default:
        icon = CupertinoIcons.checkmark_circle_fill;
        break;
    }

    late Color color;
    switch (notification.type) {
      case NotificationType.success:
        color = AppColors.primary;
        break;
      case NotificationType.fail:
        color = AppColors.red;
        break;
      case NotificationType.announcement:
        color = AppColors.amber;
        break;
      case NotificationType.generic:
        color = AppColors.cyan;
        break;
      default:
        color = AppColors.cyan;
        break;
    }

    return Icon(
      icon,
      color: color,
      size: 50,
    );
  }
}
