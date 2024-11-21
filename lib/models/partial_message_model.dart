import 'package:nearby_assist/models/message_model.dart';

class PartialMessageModel {
  String sender;
  String receiver;
  String content;

  PartialMessageModel({
    required this.sender,
    required this.receiver,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'receiver': receiver,
      'content': content,
    };
  }

  MessageModel toMessageModel() {
    return MessageModel(
      id: '',
      sender: sender,
      receiver: receiver,
      content: content,
    );
  }
}
