import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/utils/random_color.dart';

class InboxItem extends StatelessWidget {
  const InboxItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.lastMessage,
    required this.lastMessageDate,
  });

  final String imageUrl;
  final String name;
  final String lastMessage;
  final String lastMessageDate;

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
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(lastMessage),
        trailing: Text(lastMessageDate),
        onTap: () => context.pushNamed(
          'chat',
          queryParameters: {
            'recipient': 'foo',
            'recipientId': '',
          },
        ),
      ),
    );
  }
}
