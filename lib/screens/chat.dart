import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/message.dart';
import 'package:nearby_assist/model/vendor_model.dart';
import 'package:nearby_assist/services/message_service.dart';
import 'package:nearby_assist/services/vendor_service.dart';
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
      if (_scrollController.hasClients) {
        _scrollToBottom();
      }
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
            child: StreamBuilder(
              stream: getIt
                  .get<MessageService>()
                  .stream()
                  .map((event) => Message.fromJson(event)),
              builder: (context, snapshot) {
                return FutureBuilder(
                  future:
                      getIt.get<MessageService>().fetchMessages(widget.userId),
                  builder: (context, _) {
                    return ListenableBuilder(
                      listenable: getIt.get<MessageService>(),
                      builder: (context, _) {
                        final messages =
                            getIt.get<MessageService>().getMessages();

                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          _scrollToBottom();
                        });

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

  @override
  void dispose() {
    getIt.get<MessageService>().closeWebsocket();
    super.dispose();
  }
}
