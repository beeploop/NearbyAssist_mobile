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
}
