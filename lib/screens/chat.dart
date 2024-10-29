import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/message.dart';
import 'package:nearby_assist/services/logger_service.dart';
import 'package:nearby_assist/services/message_service.dart';
import 'package:nearby_assist/widgets/chat_component.dart';
import 'package:nearby_assist/widgets/popup.dart';

class Chat extends StatefulWidget {
  const Chat({super.key, required this.recipientId, required this.name});

  final String recipientId;
  final String name;

  @override
  State<Chat> createState() => _Chat();
}

class _Chat extends State<Chat> {
  @override
  void initState() {
    super.initState();

    if (getIt.get<MessageService>().isWebsocketConnected() == false) {
      getIt.get<MessageService>().connectWebsocket();
    }

    _fetchMessages();
  }

  void _fetchMessages() async {
    try {
      final messages =
          await getIt.get<MessageService>().fetchMessages(widget.recipientId);
      getIt.get<MessageService>().setInitialMessages(messages);
    } catch (e) {
      ConsoleLogger().log("Error fetcing messages: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () {
                  ConsoleLogger().log("Hire button clicked");
                },
                value: 'hire',
                child: const Text('Hire'),
              ),
              PopupMenuItem(
                onTap: () {
                  ConsoleLogger().log("View profile button clicked");
                },
                value: 'view-profile',
                child: const Text('View Profile'),
              ),
            ];
          }),
        ],
      ),
      body: FutureBuilder(
        future: getIt.get<AuthModel>().isUserVerified(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            final err = snapshot.error!;
            return Center(
              child: Text(err.toString()),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text("Unexpected behavior, no error but has no data"),
            );
          }

          final isVerified = snapshot.data!;
          if (!isVerified) {
            return PopUp(
              title: "Account not verified",
              subtitle:
                  'You need to verify your account to unlock more features',
              actions: [
                TextButton(
                  onPressed: () {
                    context.pushNamed('verifyIdentity');
                  },
                  child: const Text('Verify'),
                ),
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Back'),
                ),
              ],
            );
          }

          return StreamBuilder(
            stream: getIt.get<MessageService>().stream().map((event) {
              final decoded = jsonDecode(event);
              return Message.fromJson(decoded);
            }),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                final error = snapshot.error;

                return Center(
                  child: Text('An error occurred: $error'),
                );
              }

              if (snapshot.hasData) {
                final data = snapshot.data!;
                getIt.get<MessageService>().appendMessage(
                      data,
                      widget.recipientId,
                    );
              }

              return ChatComponent(recipientId: widget.recipientId);
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    getIt.get<MessageService>().closeWebsocket();
    super.dispose();
  }
}
