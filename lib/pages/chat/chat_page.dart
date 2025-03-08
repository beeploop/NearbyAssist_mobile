import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/partial_message_model.dart';
import 'package:nearby_assist/pages/chat/widget/menu.dart';
import 'package:nearby_assist/providers/message_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.recipientId,
    required this.recipient,
  });

  final String recipientId;
  final String recipient;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            widget.recipient,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            Menu(userId: widget.recipientId),
            const SizedBox(width: 10),
          ]),
      body: context.read<UserProvider>().user.isVerified == false
          ? Center(
              child: AlertDialog(
                icon: const Icon(CupertinoIcons.exclamationmark_triangle),
                title: const Text('Account not verified'),
                content: const Text('Verify your account to unlock feature'),
                actions: [
                  TextButton(
                    style: const ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Colors.red),
                    ),
                    onPressed: () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.green.shade800,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () => context.pushNamed('verifyAccount'),
                    child: const Text(
                      'Verify',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          : FutureBuilder(
              future: context
                  .read<MessageProvider>()
                  .fetchMessages(widget.recipientId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: AlertDialog(
                      icon: Icon(CupertinoIcons.exclamationmark_triangle),
                      title: Text('Something went wrong'),
                      content: Text(
                        'An error occurred while fetching messages. Please try again later',
                      ),
                    ),
                  );
                }

                return _chat();
              },
            ),
    );
  }

  Widget _chat() {
    final user = types.User(id: context.watch<UserProvider>().user.id);

    return Consumer<MessageProvider>(
      builder: (context, provider, child) {
        return Chat(
          theme: DefaultChatTheme(
            primaryColor: Theme.of(context).primaryColor,
            inputBorderRadius: BorderRadius.zero,
            inputBackgroundColor: Colors.transparent,
            sendButtonIcon: const Icon(
              CupertinoIcons.paperplane_fill,
              color: Colors.green,
            ),
            inputTextColor: Colors.black,
            inputTextDecoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              fillColor: Colors.grey[200],
              filled: true,
            ),
          ),
          onSendPressed: (partial) => _sendMessage(partial, user.id),
          messages: provider.getMessages(widget.recipientId),
          user: user,
        );
      },
    );
  }

  Future<void> _sendMessage(types.PartialText partial, String sender) async {
    try {
      final message = PartialMessageModel(
        sender: sender,
        receiver: widget.recipientId,
        content: partial.text,
      );

      await context.read<MessageProvider>().send(message);
    } catch (error) {
      _onSendError(error.toString());
    }
  }

  void _onSendError(String error) {
    showCustomSnackBar(
      context,
      error,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      closeIconColor: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
