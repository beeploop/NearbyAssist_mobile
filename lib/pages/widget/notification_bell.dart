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
    final count = context.watch<NotificationsProvider>().unreadCount;

    return Stack(
      children: [
        IconButton(
          icon: const Icon(CupertinoIcons.bell),
          onPressed: _handlePress,
        ),
        if (count >= 1)
          Positioned(
            top: 6,
            left: 8,
            child: GestureDetector(
              onTap: _handlePress,
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
                  '$count',
                  style: const TextStyle(color: Colors.white),
                ),
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
