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
      body: FutureBuilder(
        future: context.read<MessageProvider>().refreshInbox(),
        builder: (context, snapshot) {
          return Consumer<MessageProvider>(
            builder: (context, provider, child) {
              final inbox = provider.inbox;

              return RefreshIndicator(
                onRefresh: context.read<MessageProvider>().refreshInbox,
                child: inbox.isEmpty
                    ? _emptyState()
                    : ListView.builder(
                        itemCount: inbox.length,
                        itemBuilder: (context, index) => InboxItem(
                          inboxItem: inbox[index],
                        ),
                      ),
              );
            },
          );
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
    );
  }
}
