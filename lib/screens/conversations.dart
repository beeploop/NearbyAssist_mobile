// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
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
              return RefreshIndicator(
                onRefresh: () =>
                    getIt.get<MessageService>().fetchConversations(),
                child: ListView(
                  children: const [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 50,
                    ),
                    SizedBox(height: 10),
                    Center(child: Text('An error occurred. Try again later.')),
                  ],
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text('Unexpected behavior, no error but has no data'),
              );
            }

            final conversations = snapshot.data;

            if (conversations == null || conversations.isEmpty) {
              return const Center(
                child: Text('No messages'),
              );
            }

            return _buildConversationList(conversations);
          },
        ),
      ),
    );
  }

  Widget _buildConversationList(List<Conversation> conversations) {
    return RefreshIndicator(
      onRefresh: () => getIt.get<MessageService>().fetchConversations(),
      child: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          final date = DateTime.parse(conversation.lastMessageDate);

          return ListTile(
            onTap: () => _openConversation(conversation),
            leading: _conversationAvatar(conversation),
            title: Text(
              conversation.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(conversation.lastMessage),
            trailing: Text(DateFormat().format(date)),
          );
        },
      ),
    );
  }

  Widget _conversationAvatar(Conversation conversation) {
    return CircleAvatar(
      foregroundImage: CachedNetworkImageProvider(
        conversation.imageUrl.startsWith("http")
            ? conversation.imageUrl
            : '$addr/resource/${conversation.imageUrl}',
      ),
      onForegroundImageError: (object, stacktrace) {
        ConsoleLogger().log(
          "Error loading network image for: ${conversation.name}",
        );
      },
      backgroundImage: const AssetImage(
        'assets/images/avatar.png',
      ),
    );
  }

  void _openConversation(Conversation conversation) {
    context.pushNamed(
      'chat',
      queryParameters: {
        'vendorName': conversation.name,
        'userId': conversation.userId,
      },
    );
  }
}
