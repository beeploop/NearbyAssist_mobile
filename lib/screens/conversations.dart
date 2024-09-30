import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:nearby_assist/services/message_service.dart';
import 'package:nearby_assist/widgets/custom_drawer.dart';

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
      appBar: AppBar(),
      drawer: const CustomDrawer(),
      body: Center(
        child: FutureBuilder(
          future: getIt.get<MessageService>().fetchConversations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return const Text('messages has no data');
            }

            final conversations = snapshot.data;

            if (conversations == null || conversations.isEmpty) {
              return const Text('No messages');
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
                    onTap: () {
                      context.goNamed(
                        'chat',
                        pathParameters: {'userId': user.userId},
                        queryParameters: {'vendorName': user.name},
                      );
                    },
                    leading: CircleAvatar(
                      foregroundImage: CachedNetworkImageProvider(
                        user.imageUrl.startsWith("http")
                            ? user.imageUrl
                            : '$addr/resource/${user.imageUrl}',
                      ),
                      onForegroundImageError: (object, stacktrace) {
                        debugPrint(
                          'Error loading network image for: ${conversations[index].name}',
                        );
                      },
                      backgroundImage: const AssetImage(
                        'assets/images/avatar.png',
                      ),
                    ),
                    title: Text(conversations[index].name),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
