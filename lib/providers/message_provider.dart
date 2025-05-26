import 'package:diffie_hellman/diffie_hellman.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/conversation_model.dart';
import 'package:nearby_assist/models/inbox_preview_model.dart';
import 'package:nearby_assist/models/message_model.dart';
import 'package:nearby_assist/models/partial_message_model.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nearby_assist/models/received_message_model.dart';
import 'package:nearby_assist/services/diffie_hellman.dart';
import 'package:nearby_assist/services/encryption.dart';
import 'package:nearby_assist/services/message_service.dart';
import 'package:nearby_assist/services/secure_storage.dart';
import 'package:nearby_assist/services/user_account_service.dart';

class MessageProvider extends ChangeNotifier {
  final List<ConversationModel> _inbox = [];
  final Map<String, DhPublicKey> _publicKeyCache = {};

  void clear() {
    logger.logDebug('called clear in messages');
    _inbox.clear();
    notifyListeners();
  }

  List<InboxPreviewModel> get inbox =>
      _inbox.map((inbox) => inbox.preview).toList().reversed.toList();

  List<types.TextMessage> openConversationWith(String userId) {
    try {
      // Redundant check, will refactor later
      if (!_hasConversationWith(userId)) {
        logger.logDebug('no conversation with this user');
        return [];
      }

      final messages = _getMessagesWith(userId);
      return messages.map((msg) => msg.toTextMessage()).toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> fetchMessagesWithUser(String userId) async {
    try {
      final messages = await MessageService().fetchMessages(userId);

      for (var message in messages) {
        final decrypted = await _decrypt(message.content, userId);
        message.content = decrypted;

        // This is guaranteed to have a conversation with the user
        _addMessageToConversation(message, prepend: false);
      }
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> refreshInbox() async {
    try {
      final user = await SecureStorage().getUser();

      final inboxPreviews = await MessageService().fetchConversations();

      for (var preview in inboxPreviews) {
        final decrypted = await _decrypt(preview.lastMessage, preview.userId);
        preview.lastMessage = decrypted;
        preview.seen =
            preview.lastMessageSender == user.id ? true : preview.seen;

        if (_hasConversationWith(preview.userId)) {
          _updateInboxPreview(
            preview.userId,
            preview.lastMessage,
            preview.seen,
            createdAt: preview.lastMessageDate,
          );
        } else {
          _addInboxItem(preview);
        }
      }

      _sortInbox();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> send(PartialMessageModel partial) async {
    final newMessage = MessageModel.fromPartial(partial);

    try {
      if (!_hasConversationWith(partial.receiver)) {
        await _createInboxItem(partial.receiver, partial.content);
      }

      _addMessageToConversation(newMessage);

      final encrypted = await _encrypt(newMessage.content, newMessage.receiver);
      final encryptedMessage = newMessage.copyWith(
        content: encrypted,
        createdAt: DateTime.now(),
      );
      await MessageService().send(encryptedMessage);

      _updateMyMessageStatus(newMessage, types.Status.sent);
      _updateInboxPreview(newMessage.receiver, newMessage.content, true);
    } catch (error) {
      logger.logError(error.toString());
      _updateMyMessageStatus(newMessage, types.Status.error);
      _updateInboxPreview(newMessage.receiver, newMessage.content, true);
      rethrow;
    } finally {
      _sortInbox();
    }
  }

  Future<void> receive(ReceivedMessageModel message) async {
    try {
      final decrypted = await _decrypt(message.content, message.sender.id);
      final decryptedMessage = MessageModel(
        id: message.id,
        sender: message.sender.id,
        receiver: message.receiver.id,
        content: decrypted,
        createdAt: message.createdAt,
        seen: message.seen,
      );

      final preview = InboxPreviewModel(
        userId: message.sender.id,
        name: message.sender.name,
        imageUrl: message.sender.imageUrl,
        lastMessage: decrypted,
        lastMessageSender: message.sender.id,
        lastMessageDate: message.createdAt,
        seen: message.seen,
      );

      if (!_hasConversationWith(message.sender.id)) {
        logger.logDebug('have no conversation with: ${message.sender.id}');
        _addInboxItem(preview);
      } else {
        logger.logDebug('have conversation with: ${message.sender.id}');
        _updateInboxPreview(
          preview.userId,
          preview.lastMessage,
          preview.seen,
          createdAt: preview.lastMessageDate,
        );
      }

      _addMessageToConversation(decryptedMessage);

      _sortInbox();
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
    }
  }

// userId refers to id of the other person
  Future<void> markSeen(String userId) async {
    try {
      logger.logDebug('marking message with $userId seen');

      final messages = _getMessagesWith(userId);

      final unseen = messages.where((message) => !message.seen).toList();
      if (unseen.isEmpty) return;

      for (var msg in unseen) {
        final index = messages.indexWhere((message) => message.id == msg.id);
        // Should be guaranteed to never be -1
        messages[index].status = types.Status.seen;
      }

      final ids = unseen.map((msg) => msg.id).toList();
      await MessageService().markSeen(ids);

      _markInboxPreviewSeen(userId);
    } on DioException catch (error) {
      logger.logError(error.response?.data);
    } catch (error) {
      logger.logError(error.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<String> _encrypt(String message, String otherUserId) async {
    try {
      final dh = DiffieHellman();
      DhPublicKey? publicKey;

      if (!_publicKeyCache.containsKey(otherUserId)) {
        logger.logDebug('cache miss on encrypt');
        publicKey = await dh.getPublicKey(otherUserId);
        _publicKeyCache[otherUserId] = publicKey;
      } else {
        logger.logDebug('cache hit on encrypt');
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
        logger.logDebug('cache miss on decrypt');
        publicKey = await dh.getPublicKey(otherUserId);
        _publicKeyCache[otherUserId] = publicKey;
      } else {
        logger.logDebug('cache hit on decrypt');
        publicKey = _publicKeyCache[otherUserId]!;
      }

      final sharedSecret = await dh.computeSharedSecret(publicKey);

      final aes = Encryption.fromBigInt(sharedSecret);
      return aes.decrypt(message);
    } catch (error) {
      rethrow;
    }
  }

  bool _hasConversationWith(String userId) {
    final index = _inbox.indexWhere((inbox) => inbox.preview.userId == userId);
    return index != -1;
  }

  void _updateInboxPreview(
    String userId,
    String message,
    bool seen, {
    DateTime? createdAt,
  }) {
    final index = _inbox.indexWhere(
      (inbox) => inbox.preview.userId == userId,
    );
    if (index == -1) return;

    _inbox[index].preview.lastMessage = message;
    _inbox[index].preview.lastMessageDate = createdAt ?? DateTime.now();
    _inbox[index].preview.seen = seen;

    notifyListeners();
  }

  void _markInboxPreviewSeen(String userId) {
    final index = _inbox.indexWhere((inbox) => inbox.preview.userId == userId);
    _inbox[index].preview.seen = true;
    notifyListeners();
  }

  void _updateMyMessageStatus(MessageModel message, types.Status status) {
    final conversation = _inbox.singleWhere(
      (conversation) => conversation.preview.userId == message.receiver,
    );

    final index = conversation.messages.indexWhere(
      (msg) => msg.id == message.id,
    );
    conversation.messages[index].status = status;

    notifyListeners();
  }

  void _addInboxItem(InboxPreviewModel preview) {
    final conversation = ConversationModel(
      preview: preview,
      messages: [],
    );
    _inbox.add(conversation);
    notifyListeners();
  }

// userId = id of the recipient
  Future<void> _createInboxItem(String userId, String message) async {
    try {
      final user = await SecureStorage().getUser();
      final recipient = await UserAccountService().findUser(userId);
      final preview = InboxPreviewModel(
        userId: recipient.id,
        name: recipient.name,
        imageUrl: recipient.imageUrl,
        lastMessage: message,
        lastMessageSender: user.id,
        lastMessageDate: DateTime.now(),
        seen: true,
      );

      _addInboxItem(preview);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _addMessageToConversation(
    MessageModel message, {
    bool prepend = true,
  }) async {
    final loggedInUser = await SecureStorage().getUser();

    late int convoIndex;
    if (loggedInUser.id == message.sender) {
      convoIndex = _inbox
          .indexWhere((inbox) => inbox.preview.userId == message.receiver);
    } else {
      convoIndex =
          _inbox.indexWhere((inbox) => inbox.preview.userId == message.sender);
    }

    final msgIndex = _inbox[convoIndex].messages.indexWhere(
          (msg) => msg.id == message.id,
        );
    if (msgIndex == -1) {
      // only insert if it doesn't exists to avoid duplicate
      if (!prepend) {
        _inbox[convoIndex].messages.add(message);
      } else {
        _inbox[convoIndex].messages.insert(0, message);
      }
    }

    notifyListeners();
  }

  List<MessageModel> _getMessagesWith(String userId) {
    final index = _inbox.indexWhere((inbox) => inbox.preview.userId == userId);
    if (index == -1) return [];
    return _inbox[index].messages;
  }

  InboxPreviewModel? getChatPreview(String userId) {
    final index = _inbox.indexWhere((inbox) => inbox.preview.userId == userId);
    if (index == -1) return null;
    return _inbox[index].preview;
  }

  void _sortInbox() {
    _inbox.sort((a, b) =>
        a.preview.lastMessageDate.compareTo(b.preview.lastMessageDate));
  }
}
