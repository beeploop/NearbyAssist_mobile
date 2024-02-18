import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key, required this.userId});

  final String userId;

  @override
  State<Chat> createState() => _Chat();
}

class _Chat extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();
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
            child: ListView.builder(
              padding: const EdgeInsets.all(6),
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: 20,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(6),
                  padding: const EdgeInsets.all(10),
                  color: Colors.lightGreen,
                  child: const Text('message'),
                );
              },
            ),
          ),
          SizedBox(
            height: 60,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Form(
                        child: TextFormField(
                          onTapOutside: (_) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          controller: _messageController,
                          maxLines: 2,
                          keyboardType: TextInputType.multiline,
                          decoration:
                              const InputDecoration(hintText: 'Write message'),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _scrollToBottom();
                      },
                      child: const Icon(Icons.send),
                    )
                  ],
                ),
              ),
            ),
          ),
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
