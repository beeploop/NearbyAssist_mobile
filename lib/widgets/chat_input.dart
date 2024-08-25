import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/message_service.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({
    super.key,
    required this.scrollToBottom,
    required this.toId,
  });

  final Function scrollToBottom;
  final String toId;

  @override
  State<ChatInput> createState() => _ChatInput();
}

class _ChatInput extends State<ChatInput> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, -5),
                blurRadius: 4.0,
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(0, 0),
              )
            ],
          ),
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
                  getIt
                      .get<MessageService>()
                      .newMessage(_messageController.text, widget.toId);
                  _messageController.clear();
                  widget.scrollToBottom();
                },
                child: const Icon(Icons.send),
              )
            ],
          ),
        ),
      ),
    );
  }
}
