import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
          child: CircleAvatar(
            radius: 27,
            foregroundImage: CachedNetworkImageProvider(
              conversation.imageUrl,
            ),
            backgroundImage: const AssetImage('assets/images/profile.png'),
          ),
        ),
        title: Text(
          conversation.recipient,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Text(
          conversation.lastMessage,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
            DateFormat('MMMd h:m').format(DateTime.parse(conversation.date))),
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
