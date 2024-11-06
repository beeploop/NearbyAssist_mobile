import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/conversation_model.dart';
import 'package:nearby_assist/utils/random_color.dart';

class InboxItem extends StatelessWidget {
  const InboxItem({
    super.key,
    required this.conversation,
  });

  final ConversationModel conversation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: getRandomColor(),
          radius: 30,
          child: const CircleAvatar(
            radius: 27,
            backgroundImage: AssetImage('assets/images/avatar.png'),
          ),
        ),
        title: Text(
          conversation.recipient,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(conversation.lastMessage),
        trailing: Text(conversation.date),
        onTap: () => context.pushNamed(
          'chat',
          queryParameters: {
            'recipient': conversation.recipient,
            'recipientId': conversation.recipientId,
          },
        ),
      ),
    );
  }
}
