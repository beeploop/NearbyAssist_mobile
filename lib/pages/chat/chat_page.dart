import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nearby_assist/pages/chat/widget/menu.dart';
import 'package:nearby_assist/providers/auth_provider.dart';
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
  late MessageProvider _messageProvider;

  @override
  void initState() {
    super.initState();
    _messageProvider = Provider.of<MessageProvider>(context, listen: false);
    _messageProvider.connect();
  }

  @override
  void dispose() {
    _messageProvider.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final user = types.User(id: auth.user.id);

    return Scaffold(
      appBar: AppBar(
          title: Text(
            widget.recipient,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: const [
            Menu(),
            SizedBox(width: 10),
          ]),
      body: messageProvider.connected == false
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Chat(
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
              onSendPressed: (partial) {},
              messages: messageProvider.getMessages(widget.recipientId),
              user: user,
            ),
    );
  }
}
