// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class TextMessageModel {
  String id;
  types.User author;
  String text;
  types.Status status;
  bool showStatus;

  TextMessageModel({
    required this.id,
    required this.author,
    required this.text,
    required this.status,
    required this.showStatus,
  });

  TextMessageModel copyWithNewStatus(types.Status status) {
    return TextMessageModel(
      id: id,
      author: author,
      text: text,
      showStatus: showStatus,
      status: status,
    );
  }
}
