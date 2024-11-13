import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nearby_assist/models/partial_message_model.dart';
import 'package:nearby_assist/pages/chat/widget/menu.dart';
import 'package:nearby_assist/providers/message_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';

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
    final user = types.User(id: context.watch<UserProvider>().user.id);

    return Scaffold(
      appBar: AppBar(
          title: Text(
            widget.recipient,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            Menu(vendorId: widget.recipientId),
            const SizedBox(width: 10),
          ]),
      body: Chat(
        theme: DefaultChatTheme(
          primaryColor: Theme.of(context).primaryColor,
          inputBorderRadius: BorderRadius.zero,
          inputBackgroundColor: Colors.transparent,
          sendButtonIcon: const Icon(
            CupertinoIcons.paperplane_fill,
            color: Colors.green,
          ),
          inputTextColor: Colors.black,
          inputTextDecoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            fillColor: Colors.grey[200],
            filled: true,
          ),
        ),
        onSendPressed: (partial) {
          final message = PartialMessageModel(
            sender: user.id,
            receiver: widget.recipientId,
            content: partial.text,
          );

          context.read<MessageProvider>().send(message);
        },
        messages: const [],
        user: user,
      ),
    );
  }
}
