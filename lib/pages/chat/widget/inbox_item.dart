import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/conversation_model.dart';
import 'package:nearby_assist/utils/random_color.dart';
import 'package:nearby_assist/config/assets.dart';
import 'package:nearby_assist/utils/date_formatter.dart';

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
            backgroundImage: const AssetImage(Assets.profile),
          ),
        ),
        title: AutoSizeText(
          conversation.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Text(
          conversation.lastMessage,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(DateFormatter.monthDateHourMinutes(conversation.date)),
        onTap: () => context.pushNamed(
          'chat',
          queryParameters: {
            'recipient': conversation.name,
            'recipientId': conversation.userId,
          },
        ),
      ),
    );
  }
}
