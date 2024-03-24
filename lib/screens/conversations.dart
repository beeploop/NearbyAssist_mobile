import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/message_service.dart';
import 'package:nearby_assist/widgets/custom_drawer.dart';

class Conversations extends StatefulWidget {
  const Conversations({super.key});

  @override
  State<Conversations> createState() => _Conversations();
}

class _Conversations extends State<Conversations> {
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

            if (snapshot.hasData) {
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
                    return ListTile(
                      onTap: () {
                        context.goNamed(
                          'chat',
                          pathParameters: {
                            'userId': '${conversations[index].userId}'
                          },
                          queryParameters: {
                            'vendorName': conversations[index].name
                          },
                        );
                      },
                      leading: CircleAvatar(
                        foregroundImage: NetworkImage(
                          conversations[index].imageUrl,
                        ),
                      ),
                      title: Text(conversations[index].name),
                    );
                  },
                ),
              );
            }

            return const Text('No messages');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.goNamed('new-message');
        },
        icon: const Icon(Icons.add),
        label: const Text('New Message'),
      ),
    );
  }
}
