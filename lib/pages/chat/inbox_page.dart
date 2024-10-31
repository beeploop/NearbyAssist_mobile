import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/chat/widget/inbox_item.dart';

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
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.delayed(const Duration(seconds: 1)),
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) => const InboxItem(
            name: "some person's name",
            lastMessage: "last sent message",
            imageUrl: "",
            lastMessageDate: "10/31/24",
          ),
        ),
      ),
    );
  }
}
