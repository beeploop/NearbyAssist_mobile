import 'package:flutter/material.dart';
import 'package:nearby_assist/config/theme/app_colors.dart';
import 'package:nearby_assist/models/notification_model.dart';
import 'package:nearby_assist/pages/notification/widget/generic_notification.dart';

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
      backgroundColor: AppColors.greyLighter,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GenericNotification(notification: widget.notification),
      ),
    );
  }
}
