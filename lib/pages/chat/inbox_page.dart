import 'package:flutter/cupertino.dart';
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
                children: [
                  SingleChildScrollView(
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.envelope_open,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'No messages',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
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
