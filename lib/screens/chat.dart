import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/message.dart';
import 'package:nearby_assist/services/message_service.dart';
import 'package:nearby_assist/widgets/chat_input.dart';

class Chat extends StatefulWidget {
  const Chat({super.key, required this.userId, required this.name});

  final int userId;
  final String name;

  @override
  State<Chat> createState() => _Chat();
}

class _Chat extends State<Chat> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if (getIt.get<MessageService>().isWebsocketConnected() == false) {
      getIt.get<MessageService>().connectWebsocket();
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getIt.get<MessageService>().fetchMessages(widget.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  final error = snapshot.error;

                  return Center(
                    child: Text('An error occurred: $error'),
                  );
                }

                if (snapshot.hasData) {
                  final initialMessages = snapshot.data;

                  if (initialMessages == null) {
                    return const Center(
                      child: Text(
                        'Something went wrong. Please try again later.',
                      ),
                    );
                  }

                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  return StreamBuilder(
                    stream: getIt.get<MessageService>().stream().map((event) {
                      debugPrint('====== event: $event');
                      final message = jsonDecode(event);
                      return Message.fromJson(message);
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
                        initialMessages.add(data);

                        return ListView.builder(
                          padding: const EdgeInsets.all(6),
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: initialMessages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.all(6),
                              padding: const EdgeInsets.all(10),
                              color: Colors.lightGreen,
                              child: Text(initialMessages[index].content),
                            );
                          },
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(6),
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: initialMessages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(6),
                            padding: const EdgeInsets.all(10),
                            color: Colors.lightGreen,
                            child: Text(initialMessages[index].content),
                          );
                        },
                      );
                    },
                  );
                }

                return const Center(
                  child: Text('Something went wrong. Please try again later.'),
                );
              },
            ),
          ),
          ChatInput(scrollToBottom: _scrollToBottom, toId: widget.userId),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  void dispose() {
    getIt.get<MessageService>().closeWebsocket();
    super.dispose();
  }
}
