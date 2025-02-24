import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/providers/notifications_provider.dart';
import 'package:provider/provider.dart';

class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  @override
  Widget build(BuildContext context) {
    final notificationCount =
        context.watch<NotificationsProvider>().notifications.length;

    return Stack(
      children: [
        IconButton(
          icon: const Icon(CupertinoIcons.bell),
          onPressed: _handlePress,
        ),
        if (notificationCount >= 1)
          Positioned(
            top: 6,
            left: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
                border: Border.all(
                  color: Colors.red,
                ),
              ),
              child: Text(
                '$notificationCount',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  void _handlePress() {
    context.pushNamed('notifications');
  }
}
