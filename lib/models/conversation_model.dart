import 'package:nearby_assist/models/inbox_preview_model.dart';
import 'package:nearby_assist/models/message_model.dart';

class ConversationModel {
  InboxPreviewModel preview;
  List<MessageModel> messages;

  ConversationModel({
    required this.preview,
    required this.messages,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      preview: InboxPreviewModel.fromJson(json['preview']),
      messages: ((json['messages'] ?? []) as List)
          .map((msg) => MessageModel.fromJson(msg))
          .toList(),
    );
  }
}
