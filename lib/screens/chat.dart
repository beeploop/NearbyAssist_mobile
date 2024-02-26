import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/message_service.dart';
import 'package:nearby_assist/widgets/chat_input.dart';

class Chat extends StatefulWidget {
  const Chat({super.key, required this.userId});

  final int userId;

  @override
  State<Chat> createState() => _Chat();
}

class _Chat extends State<Chat> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User ${widget.userId}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getIt.get<MessageService>().fetchMessages(widget.userId),
              builder: (context, snapshot) {
                final messages = getIt.get<MessageService>().getMessages();

                return ListenableBuilder(
                  listenable: getIt.get<MessageService>(),
                  builder: (context, child) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(6),
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(6),
                          padding: const EdgeInsets.all(10),
                          color: Colors.lightGreen,
                          child: Text(messages[index].content),
                        );
                      },
                    );
                  },
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
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }
}
