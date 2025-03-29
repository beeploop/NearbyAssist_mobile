// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nearby_assist/models/partial_message_model.dart';
import 'package:uuid/uuid.dart';

class MessageModel {
  String id;
  String sender;
  String receiver;
  String content;
  types.Status status;

  MessageModel({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.content,
    this.status = types.Status.sent,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      sender: json['sender'],
      receiver: json['receiver'],
      content: json['content'],
      status: types.Status.sent,
    );
  }

  factory MessageModel.fromPartial(PartialMessageModel partial) {
    return MessageModel(
      id: const Uuid().v4(),
      sender: partial.sender,
      receiver: partial.receiver,
      content: partial.content,
      status: types.Status.sending,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'content': content,
    };
  }

  MessageModel copyWithNewContent(String content) {
    return MessageModel(
      id: id,
      sender: sender,
      receiver: receiver,
      content: content,
    );
  }

  MessageModel copyWithNewStatus(types.Status status) {
    return MessageModel(
      id: id,
      sender: sender,
      receiver: receiver,
      content: content,
      status: status,
    );
  }

  types.TextMessage toTextMessage() {
    return types.TextMessage(
      id: id,
      author: types.User(id: sender),
      text: content,
      showStatus: true,
      status: status,
    );
  }

  /// Does not take into account the content
  bool isPartialEqual(MessageModel message) {
    if (sender == message.sender &&
        receiver == message.receiver &&
        content == message.content &&
        status == types.Status.sending) {
      return true;
    }

    return false;
  }

  bool isSending() {
    if (status == types.Status.sending) return true;
    return false;
  }
}
