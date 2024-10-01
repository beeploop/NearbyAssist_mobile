import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/message.dart';
import 'package:nearby_assist/services/message_service.dart';
import 'package:nearby_assist/widgets/chat_component.dart';

class Chat extends StatefulWidget {
  const Chat({super.key, required this.recipientId, required this.name});

  final String recipientId;
  final String name;

  @override
  State<Chat> createState() => _Chat();
}

class _Chat extends State<Chat> {
  @override
  void initState() {
    super.initState();

    if (getIt.get<MessageService>().isWebsocketConnected() == false) {
      getIt.get<MessageService>().connectWebsocket();
    }

    _fetchMessages();
  }

  void _fetchMessages() async {
    try {
      final messages =
          await getIt.get<MessageService>().fetchMessages(widget.recipientId);
      getIt.get<MessageService>().setInitialMessages(messages);
    } catch (e) {
      debugPrint('Error fetching messages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
        stream: getIt.get<MessageService>().stream().map((event) {
          final decoded = jsonDecode(event);
          return Message.fromJson(decoded);
        }),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;

            return Center(
              child: Text('An error occurred: $error'),
            );
          }

          if (snapshot.hasData) {
            final data = snapshot.data!;
            getIt.get<MessageService>().appendMessage(
                  data,
                  widget.recipientId,
                );
          }

          return ChatComponent(recipientId: widget.recipientId);
        },
      ),
    );
  }

  @override
  void dispose() {
    getIt.get<MessageService>().closeWebsocket();
    super.dispose();
  }
}
