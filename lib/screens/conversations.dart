import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/conversation.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:nearby_assist/services/logger_service.dart';
import 'package:nearby_assist/services/message_service.dart';

class Conversations extends StatefulWidget {
  const Conversations({super.key});

  @override
  State<Conversations> createState() => _Conversations();
}

class _Conversations extends State<Conversations> {
  final addr = getIt.get<SettingsModel>().getServerAddr();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Messages',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: getIt.get<MessageService>().fetchConversations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text('An error occurred. Try again later.'),
                ],
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text('messages has no data'),
              );
            }

            final conversations = snapshot.data;

            if (conversations == null || conversations.isEmpty) {
              return const Center(
                child: Text('No messages'),
              );
            }

            return RefreshIndicator(
              onRefresh: () {
                return getIt.get<MessageService>().fetchConversations();
              },
              child: ListView.builder(
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final user = conversations[index];

                  return ListTile(
                    onTap: () => _openConversation(user),
                    leading: _conversationAvatar(user),
                    title: Text(user.name),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _conversationAvatar(Conversation user) {
    return CircleAvatar(
      foregroundImage: CachedNetworkImageProvider(
        user.imageUrl.startsWith("http")
            ? user.imageUrl
            : '$addr/resource/${user.imageUrl}',
      ),
      onForegroundImageError: (object, stacktrace) {
        ConsoleLogger().log(
          "Error loading network image for: ${user.name}",
        );
      },
      backgroundImage: const AssetImage(
        'assets/images/avatar.png',
      ),
    );
  }

  void _openConversation(Conversation user) {
    context.goNamed(
      'chat',
      queryParameters: {
        'vendorName': user.name,
        'userId': user.userId,
      },
    );
  }
}
