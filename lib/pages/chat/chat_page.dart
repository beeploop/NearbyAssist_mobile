import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nearby_assist/config/theme/app_colors.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MessageProvider>(context, listen: false)
          .markSeen(widget.recipientId);
    });
  }

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
          ]),
      body: FutureBuilder(
        future: context
            .read<MessageProvider>()
            .fetchMessagesWithUser(widget.recipientId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _errorState();
          }

          return _chat();
        },
      ),
    );
  }

  Widget _chat() {
    return Consumer2<UserProvider, MessageProvider>(
      builder: (context, userProvider, messageProvider, child) {
        final user = userProvider.user;

        return Chat(
          theme: DefaultChatTheme(
            primaryColor: AppColors.primary,
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
              fillColor: Colors.grey.shade200,
              filled: true,
            ),
          ),
          dateIsUtc: true,
          onSendPressed: (partial) => _sendMessage(partial, user.id),
          messages: messageProvider.openConversationWith(widget.recipientId),
          user: types.User(id: user.id, imageUrl: user.imageUrl),
        );
      },
    );
  }

  Widget _errorState() {
    return const Center(
      child: AlertDialog(
        icon: Icon(CupertinoIcons.exclamationmark_triangle),
        title: Text('Something went wrong'),
        content: Text(
          'An error occurred while fetching data of this vendor. Please try again later',
        ),
      ),
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
