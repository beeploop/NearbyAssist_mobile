import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/notification_model.dart';
import 'package:nearby_assist/pages/notification/notification_page.dart';
import 'package:nearby_assist/providers/notifications_provider.dart';
import 'package:provider/provider.dart';

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});

  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: context.read<NotificationsProvider>().fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: AlertDialog(
                icon: Icon(
                  CupertinoIcons.exclamationmark_triangle,
                  color: Colors.amber,
                  size: 30,
                ),
                title: Text('Something went wrong'),
                content: Text(
                  'Oops! An error occurred while retrieving notifications, try again later',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final notifications =
              context.watch<NotificationsProvider>().notifications;

          return notifications.isEmpty
              ? _emptyState()
              : _mainContent(notifications);
        },
      ),
    );
  }

  Widget _emptyState() {
    return ListView(
      children: [
        SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.tray,
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Text(
                  'No notifications',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _mainContent(List<NotificationModel> notifications) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: notifications.length,
        itemBuilder: (context, idx) => Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: ListTile(
            onTap: () {
              context
                  .read<NotificationsProvider>()
                  .readNotification(notifications[idx].id);

              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => NotificationPage(
                    notification: notifications[idx],
                  ),
                ),
              );
            },
            leading: const Icon(CupertinoIcons.bell_circle, size: 40),
            title: Text(
              notifications[idx].title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              notifications[idx].content,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
