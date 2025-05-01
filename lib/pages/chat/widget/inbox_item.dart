import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/inbox_preview_model.dart';
import 'package:nearby_assist/utils/random_color.dart';
import 'package:nearby_assist/config/assets.dart';
import 'package:nearby_assist/utils/date_formatter.dart';

class InboxItem extends StatelessWidget {
  const InboxItem({
    super.key,
    required this.inboxItem,
  });

  final InboxPreviewModel inboxItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: getRandomColor(),
        radius: 30,
        child: CircleAvatar(
          radius: 27,
          foregroundImage: CachedNetworkImageProvider(
            inboxItem.imageUrl,
          ),
          backgroundImage: const AssetImage(Assets.profile),
        ),
      ),
      titleAlignment: ListTileTitleAlignment.bottom,
      title: AutoSizeText(
        inboxItem.name,
        style: TextStyle(
          fontWeight: inboxItem.seen ? FontWeight.normal : FontWeight.bold,
          color: Colors.black,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: Text(
        inboxItem.lastMessage,
        style: TextStyle(
          fontWeight: inboxItem.seen ? FontWeight.normal : FontWeight.bold,
          color: inboxItem.seen ? Colors.black87 : Colors.black,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      trailing: Text(
        DateFormatter.monthDateHourMinutesFromDT(
          inboxItem.lastMessageDate,
        ),
        style: TextStyle(
          fontWeight: inboxItem.seen ? FontWeight.normal : FontWeight.bold,
          color: inboxItem.seen ? Colors.black87 : Colors.black,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => context.pushNamed(
        'chat',
        queryParameters: {
          'recipient': inboxItem.name,
          'recipientId': inboxItem.userId,
        },
      ),
    );
  }
}
