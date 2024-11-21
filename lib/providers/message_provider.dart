import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/conversation_model.dart';
import 'package:nearby_assist/models/message_model.dart';
import 'package:nearby_assist/models/partial_message_model.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nearby_assist/services/message_service.dart';

class MessageProvider extends ChangeNotifier {
  List<ConversationModel> _conversations = [];
  final Map<String, List<MessageModel>> _messages = {};

  List<ConversationModel> getConversations() => _conversations;

  List<types.TextMessage> getMessages(String recipientId) {
    try {
      if (_messages.containsKey(recipientId)) {
        return _messages[recipientId]!.map((e) => e.toTextMessage()).toList();
      }

      return [];
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchMessages(String recipientId) async {
    try {
      final messageService = MessageService();
      final messages = await messageService.fetchMessages(recipientId);

      _messages[recipientId] = messages;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> refreshConversations() async {
    try {
      final messageService = MessageService();
      final conversations = await messageService.fetchConversations();

      _conversations = conversations;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> send(PartialMessageModel message) async {
    try {
      if (_messages.containsKey(message.receiver)) {
        // TODO: Improve this.
        // Disables sending message while another message is still sending because
        // I can't think of a way to replace the status of the right message when sent
        // Without breaking flutter rules.
        // See addMessage() function, it's related.
        // Skill issues, I know :(((
        if (_messages[message.receiver]![0].status == types.Status.sending) {
          throw 'Spam detected, wait until previous message is sent.';
        }

        _messages[message.receiver]!
            .insert(0, MessageModel.fromPartial(message));
      } else {
        _messages[message.receiver] = [];
        _messages[message.receiver]!
            .insert(0, MessageModel.fromPartial(message));
      }

      notifyListeners();

      final messageService = MessageService();
      await messageService.send(message);
    } catch (error) {
      rethrow;
    }
  }

  void addMessage(MessageModel message) {
    if (_messages.containsKey(message.receiver)) {
      // NOTE: Related to spam detection
      // Also temporary solution.
      final target = _messages[message.receiver]!
          .indexWhere((msg) => msg.isPartialEqual(message));

      if (target == -1) {
        logger.log('Target not found');
        _messages[message.receiver]!.insert(0, message);
      } else {
        _messages[message.receiver]![target] =
            message.copyWithNewStatus(types.Status.sent);
      }
    } else {
      _messages[message.receiver] = [];
      _messages[message.receiver]!.insert(0, message);
    }

    notifyListeners();
  }
}
