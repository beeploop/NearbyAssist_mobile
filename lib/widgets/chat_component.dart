import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/services/message_service.dart';

class ChatComponent extends StatefulWidget {
  const ChatComponent({
    super.key,
    required this.recipientId,
  });

  final String recipientId;

  @override
  State<ChatComponent> createState() => _ChatComponent();
}

class _ChatComponent extends State<ChatComponent> {
  late String userId;

  @override
  void initState() {
    super.initState();
    try {
      userId = getIt.get<AuthModel>().getUserId();
    } catch (err) {
      if (kDebugMode) {
        print("Error getting user id: $err");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: getIt.get<MessageService>(),
      builder: (context, _) {
        final messages = getIt
            .get<MessageService>()
            .getMessages()
            .map((message) {
              return types.TextMessage(
                id: message.id.toString(),
                author: types.User(id: message.sender.toString()),
                text: message.content,
              );
            })
            .toList()
            .reversed
            .toList();

        return Chat(
          theme: DefaultChatTheme(
            primaryColor: Theme.of(context).primaryColor,
            inputBorderRadius: BorderRadius.zero,
          ),
          messages: messages,
          onSendPressed: (types.PartialText text) {
            getIt
                .get<MessageService>()
                .newMessage(text.text, widget.recipientId);
          },
          user: types.User(id: userId.toString()),
        );
      },
    );
  }
}
