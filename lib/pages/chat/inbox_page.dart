import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/chat/widget/inbox_item.dart';
import 'package:nearby_assist/pages/widget/notification_bell.dart';
import 'package:nearby_assist/providers/inbox_provider.dart';
import 'package:provider/provider.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  Widget build(BuildContext context) {
    final conversations = context.watch<InboxProvider>().conversations;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Inbox',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          NotificationBell(),
          SizedBox(width: 10),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.delayed(const Duration(seconds: 1)),
        child: conversations.isEmpty
            ? const Center(
                child: Text('no messages'),
              )
            : ListView.builder(
                itemCount: conversations.length,
                itemBuilder: (context, index) => InboxItem(
                  conversation: conversations[index],
                ),
              ),
      ),
    );
  }
}
