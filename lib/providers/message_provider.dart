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
            await _decrypt(conversation.lastMessage, conversation.recipientId);
        conversation.lastMessage = decrypted;

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
      final newPlainMessage = MessageModel.fromPartial(message);

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

        _messages[message.receiver]!.insert(0, newPlainMessage);
      } else {
        _messages[message.receiver] = [];
        _messages[message.receiver]!.insert(0, newPlainMessage);
      }

      notifyListeners();

      final encrypted = await _encrypt(message.content, message.receiver);
      final encryptedMessage = message.copyWithNewContent(encrypted);

      final messageService = MessageService();
      await messageService.send(encryptedMessage);
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
      final decrypted = await _decrypt(message.content, message.receiver);
      final decryptedMessage = message.copyWithNewContent(decrypted);

      if (_messages.containsKey(message.receiver)) {
        final messages = _messages[message.receiver]!;

        // NOTE: Related to spam detection
        // Also temporary solution.
        final target =
            messages.indexWhere((msg) => msg.isPartialEqual(decryptedMessage));

        if (target == -1) {
          messages.insert(
              0, decryptedMessage.copyWithNewStatus(types.Status.sent));
        } else {
          messages[target] =
              decryptedMessage.copyWithNewStatus(types.Status.sent);
        }
      } else {
        _messages[decryptedMessage.receiver] = [];
        _messages[decryptedMessage.receiver]!
            .insert(0, decryptedMessage.copyWithNewStatus(types.Status.sent));
      }
    } else {
      // Case 2: I am the receiver, so check the cache for the sender
      final decrypted = await _decrypt(message.content, message.sender);
      final decryptedMessage = message.copyWithNewContent(decrypted);

      if (_messages.containsKey(message.sender)) {
        final messages = _messages[message.sender]!;

        // NOTE: Related to spam detection
        // Also temporary solution.
        final target =
            messages.indexWhere((msg) => msg.isPartialEqual(decryptedMessage));

        if (target == -1) {
          messages.insert(
              0, decryptedMessage.copyWithNewStatus(types.Status.sent));
        } else {
          messages[target] =
              decryptedMessage.copyWithNewStatus(types.Status.sent);
        }
      } else {
        _messages[decryptedMessage.sender] = [];
        _messages[decryptedMessage.sender]!
            .insert(0, decryptedMessage.copyWithNewStatus(types.Status.sent));
      }
    }

    notifyListeners();
  }

  Future<String> _encrypt(String message, String otherUserId) async {
    try {
      final dh = DiffieHellman();
      DhPublicKey? publicKey;

      if (!_publicKeyCache.containsKey(otherUserId)) {
        logger.log("Public key cache miss");
        publicKey = await dh.getPublicKey(otherUserId);
        _publicKeyCache[otherUserId] = publicKey;
      } else {
        logger.log("Public key cache hit");
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
        logger.log("Public key cache miss");
        publicKey = await dh.getPublicKey(otherUserId);
        _publicKeyCache[otherUserId] = publicKey;
      } else {
        logger.log("Public key cache hit");
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
