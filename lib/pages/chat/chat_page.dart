import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

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
  final List<types.Message> _messages = [];
  late types.User _user;

  @override
  void initState() {
    super.initState();
    _user = types.User(id: widget.recipientId, firstName: widget.recipient);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            _user.firstName ?? _user.id,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.ellipsis),
              onPressed: () {},
            ),
            const SizedBox(width: 10),
          ]),
      body: Chat(
        theme: DefaultChatTheme(
          primaryColor: Theme.of(context).primaryColor,
          inputBorderRadius: BorderRadius.zero,
          inputBackgroundColor: Colors.grey[800]!,
          attachmentButtonIcon: const Icon(
            CupertinoIcons.paperclip,
            color: Colors.white,
          ),
        ),
        onSendPressed: _addMessage,
        messages: _messages,
        user: _user,
      ),
    );
  }

  void _addMessage(types.PartialText message) {
    final text = types.TextMessage.fromPartial(
      partialText: message,
      author: _user,
      id: _messages.length.toString(),
      showStatus: true,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      status: types.Status.sending,
    );

    setState(() {
      _messages.insert(0, text);
    });
  }
}
