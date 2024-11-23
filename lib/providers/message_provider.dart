import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/conversation_model.dart';
import 'package:nearby_assist/models/message_model.dart';
import 'package:nearby_assist/models/partial_message_model.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nearby_assist/services/message_service.dart';
import 'package:nearby_assist/services/secure_storage.dart';

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

      for (var conversation in conversations) {
        if (_messages.containsKey(conversation.recipientId)) {
          continue;
        }

        _messages[conversation.recipientId] = [];
      }

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
        // See receive() function, it's related.
        // Skill issues, I know :(((
        final messages = _messages[message.receiver]!;
        if (messages.isEmpty == false &&
            messages[0].status == types.Status.sending) {
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

  Future<void> receive(MessageModel message) async {
    final user = await SecureStorage().getUser();
    if (user == null) {
      throw Exception('NoUser');
    }

    // Case 1: I am the sender, so check the cache for the receiver
    if (message.sender == user.id) {
      if (_messages.containsKey(message.receiver)) {
        final messages = _messages[message.receiver]!;

        // NOTE: Related to spam detection
        // Also temporary solution.
        final target =
            messages.indexWhere((msg) => msg.isPartialEqual(message));

        if (target == -1) {
          messages.insert(0, message.copyWithNewStatus(types.Status.sent));
        } else {
          messages[target] = message.copyWithNewStatus(types.Status.sent);
        }
      } else {
        _messages[message.receiver] = [];
        _messages[message.receiver]!
            .insert(0, message.copyWithNewStatus(types.Status.sent));
      }
    } else {
      // Case 2: I am the receiver, so check the cache for the sender
      if (_messages.containsKey(message.sender)) {
        final messages = _messages[message.sender]!;

        // NOTE: Related to spam detection
        // Also temporary solution.
        final target =
            messages.indexWhere((msg) => msg.isPartialEqual(message));

        if (target == -1) {
          messages.insert(0, message.copyWithNewStatus(types.Status.sent));
        } else {
          messages[target] = message.copyWithNewStatus(types.Status.sent);
        }
      } else {
        _messages[message.sender] = [];
        _messages[message.sender]!
            .insert(0, message.copyWithNewStatus(types.Status.sent));
      }
    }

    notifyListeners();
  }
}
