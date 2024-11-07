import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nearby_assist/models/conversation_model.dart';
import 'package:nearby_assist/pages/chat/widget/menu.dart';
import 'package:nearby_assist/providers/inbox_provider.dart';
import 'package:nearby_assist/providers/message_provider.dart';
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
  late types.User _user;

  @override
  void initState() {
    super.initState();
    _user = types.User(id: widget.recipientId, firstName: widget.recipient);
  }

  @override
  Widget build(BuildContext context) {
    final messages =
        context.watch<MessageProvider>().getMessages(widget.recipientId);

    final messageProvider = context.read<MessageProvider>();
    final inboxProvider = context.read<InboxProvider>();

    return Scaffold(
      appBar: AppBar(
          title: Text(
            _user.firstName ?? _user.id,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: const [
            Menu(),
            SizedBox(width: 10),
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
        onSendPressed: (message) => _addMessage(
          inboxProvider,
          messageProvider,
          message,
        ),
        messages: messages,
        user: _user,
      ),
    );
  }

  void _addMessage(
    InboxProvider inbox,
    MessageProvider provider,
    types.PartialText message,
  ) {
    final id = Random().nextInt(100).toString();

    final text = types.TextMessage.fromPartial(
      partialText: message,
      author: _user,
      id: id,
      showStatus: true,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      status: types.Status.sending,
    );

    provider.newMessage(widget.recipientId, text);

    final now = DateTime.now().toIso8601String();

    if (inbox.includes(widget.recipientId)) {
      inbox.updateConversation(widget.recipientId, message.text, now);
      return;
    }

    inbox.add(ConversationModel(
      recipientId: widget.recipientId,
      recipient: widget.recipient,
      imageUrl: 'assets/images/avatar.png',
      lastMessage: message.text,
      date: now,
    ));
  }
}
