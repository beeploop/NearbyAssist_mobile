// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class MessageModel {
  String id;
  String sender;
  String receiver;
  String content;

  MessageModel({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.content,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      sender: json['sender'],
      receiver: json['receiver'],
      content: json['content'],
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

  types.TextMessage toTextMessage() {
    return types.TextMessage(
      id: id,
      author: types.User(id: sender),
      text: content,
      showStatus: true,
      status: types.Status.sending,
    );
  }
}
