import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.recipientId,
    required this.recipient,
  });

  final String recipientId;
  final String recipient;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipient,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Text("chat"),
      ),
    );
  }
}
