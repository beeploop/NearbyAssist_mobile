import 'package:diffie_hellman/diffie_hellman.dart';
import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/conversation_model.dart';
import 'package:nearby_assist/models/message_model.dart';
import 'package:nearby_assist/models/partial_message_model.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nearby_assist/services/diffie_hellman.dart';
import 'package:nearby_assist/services/encryption.dart';
import 'package:nearby_assist/services/message_service.dart';
import 'package:nearby_assist/services/secure_storage.dart';

class MessageProvider extends ChangeNotifier {
  List<ConversationModel> _conversations = [];
  final Map<String, List<MessageModel>> _messages = {};
  final Map<String, DhPublicKey> _publicKeyCache = {};

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

      for (var entry in messages) {
        final decrypted = await _decrypt(entry.content, recipientId);
        entry.content = decrypted;
      }

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
        final decrypted =
            await _decrypt(conversation.lastMessage, conversation.userId);
        conversation.lastMessage = decrypted;

        if (_messages.containsKey(conversation.userId)) {
          continue;
        }

        _messages[conversation.userId] = [];
      }

      _conversations = conversations;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> send(PartialMessageModel partial) async {
    final newMessage = MessageModel.fromPartial(partial);

    try {
      if (_messages.containsKey(newMessage.receiver)) {
        _messages[newMessage.receiver]!.insert(0, newMessage);
      } else {
        _messages[newMessage.receiver] = [newMessage];
      }
      notifyListeners();

      // Send message
      final encrypted = await _encrypt(newMessage.content, newMessage.receiver);
      final encryptedMessage = newMessage.copyWithNewContent(encrypted);

      final messageService = MessageService();
      await messageService.send(encryptedMessage);

      // Update status to sent
      _updateMessageStatus(newMessage, types.Status.sent);

      // Update conversations
      _updateConversations(partial);
    } catch (error) {
      // Update status to error
      _updateMessageStatus(newMessage, types.Status.error);
      rethrow;
    }
  }

  void _updateMessageStatus(MessageModel message, types.Status status) {
    if (_messages.containsKey(message.receiver)) {
      final messages = _messages[message.receiver]!;

      final index = messages.indexWhere((msg) => msg.id == message.id);
      if (index == -1) return;

      final updatedMessage = messages[index].copyWithNewStatus(status);
      _messages[message.receiver]![index] = updatedMessage;
      notifyListeners();
    }
  }

  void _updateConversations(PartialMessageModel partial) async {
    try {
      final user = await SecureStorage().getUser();

      final index = _conversations.indexWhere((conversation) {
        if (partial.sender == user.id) {
          return conversation.userId == partial.receiver;
        }

        return conversation.userId == partial.sender;
      });

      if (index == -1) {
        logger.logDebug(
            'no previous conversations, calling refreshConversations');
        // NOTE: Could be better, instead of refetching we can update the
        // inbox, but message would need to have the receiver's image URL, id,
        // and name. Too much work for now.
        refreshConversations();
        return;
      }

      final conversation = _conversations[index];
      conversation.lastMessage = partial.content;
      conversation.date = DateTime.now().toIso8601String();

      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
    }
  }

  Future<void> receive(MessageModel message) async {
    try {
      final decrypted = await _decrypt(message.content, message.sender);
      final decryptedMessage = message.copyWithNewContent(decrypted);

      if (_messages.containsKey(message.sender)) {
        final messages = _messages[message.sender]!;
        messages.insert(0, decryptedMessage);
      } else {
        _messages[decryptedMessage.sender] = [decryptedMessage];
      }
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
    } finally {
      refreshConversations(); // trigger refreshConversation to update inbox
    }
  }

  Future<String> _encrypt(String message, String otherUserId) async {
    try {
      final dh = DiffieHellman();
      DhPublicKey? publicKey;

      if (!_publicKeyCache.containsKey(otherUserId)) {
        logger.logDebug('cache miss on encrypt in message_provider.dart');

        publicKey = await dh.getPublicKey(otherUserId);
        _publicKeyCache[otherUserId] = publicKey;
      } else {
        logger.logDebug('cache hit on encrypt in message_provider.dart');

        publicKey = _publicKeyCache[otherUserId]!;
      }

      final sharedSecret = await dh.computeSharedSecret(publicKey);

      final aes = Encryption.fromBigInt(sharedSecret);
      return aes.encrypt(message);
    } catch (error) {
      rethrow;
    }
  }

  Future<String> _decrypt(String message, String otherUserId) async {
    try {
      final dh = DiffieHellman();
      DhPublicKey? publicKey;

      if (!_publicKeyCache.containsKey(otherUserId)) {
        logger.logDebug('cache miss on decrypt in message_provider.dart');

        publicKey = await dh.getPublicKey(otherUserId);
        _publicKeyCache[otherUserId] = publicKey;
      } else {
        logger.logDebug('cache hit on decrypt in message_provider.dart');

        publicKey = _publicKeyCache[otherUserId]!;
      }

      final sharedSecret = await dh.computeSharedSecret(publicKey);

      final aes = Encryption.fromBigInt(sharedSecret);
      return aes.decrypt(message);
    } catch (error) {
      rethrow;
    }
  }
}
