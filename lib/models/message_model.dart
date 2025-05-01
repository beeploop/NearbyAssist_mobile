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
  bool seen;
  DateTime? seenAt;
  DateTime createdAt;

  MessageModel({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.content,
    this.status = types.Status.sent,
    required this.seen,
    this.seenAt,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      sender: json['sender'],
      receiver: json['receiver'],
      content: json['content'],
      status: types.Status.sent,
      seen: json['seen'],
      seenAt: DateTime.tryParse(json['seenAt']),
      createdAt: DateTime.parse(json['createdAt']),
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

  factory MessageModel.fromPartial(PartialMessageModel partial) {
    return MessageModel(
      id: const Uuid().v4(),
      sender: partial.sender,
      receiver: partial.receiver,
      content: partial.content,
      status: types.Status.sending,
      seen: true,
      createdAt: DateTime.now(),
    );
  }

  PartialMessageModel toPartial() {
    return PartialMessageModel(
      sender: sender,
      receiver: receiver,
      content: content,
    );
  }

  MessageModel copyWith({String? content, types.Status? status, bool? seen}) {
    return MessageModel(
      id: id,
      sender: sender,
      receiver: receiver,
      content: content ?? this.content,
      status: status ?? this.status,
      seen: seen ?? this.seen,
      createdAt: DateTime.now(),
    );
  }

  types.TextMessage toTextMessage() {
    return types.TextMessage(
      id: id,
      author: types.User(id: sender),
      text: content,
      showStatus: true,
      status: status,
      createdAt: createdAt.millisecondsSinceEpoch,
    );
  }
}
