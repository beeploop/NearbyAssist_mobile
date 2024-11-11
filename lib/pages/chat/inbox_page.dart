import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/chat/widget/inbox_item.dart';
import 'package:nearby_assist/pages/widget/notification_bell.dart';
import 'package:nearby_assist/providers/message_provider.dart';
import 'package:provider/provider.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  Widget build(BuildContext context) {
    final conversations = Provider.of<MessageProvider>(context).conversations;

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
        onRefresh: Provider.of<MessageProvider>(context).fetchConversations,
        child: conversations.isEmpty
            ? ListView(
                children: const [
                  Center(child: Text('No conversations yet')),
                ],
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
