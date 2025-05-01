import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/inbox_preview_model.dart';
import 'package:nearby_assist/models/message_model.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/utils/pretty_json.dart';

class MessageService {
  Future<void> send(MessageModel message) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.post(endpoint.sendMessage, data: message.toJson());
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> markSeen(List<String> messageIDs) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.put(
        endpoint.markSeen,
        data: {'messageIds': messageIDs},
      );
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<List<MessageModel>> fetchMessages(String recipeintId) async {
    try {
      final api = ApiService.authenticated();
      final response =
          await api.dio.get('${endpoint.getMessages}/$recipeintId');
      logger.logInfo(prettyJSON(response.data['messages']));

      return (response.data['messages'] as List)
          .map((message) => MessageModel.fromJson(message))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<List<InboxPreviewModel>> fetchConversations() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.conversations);

      return (response.data['conversations'] as List)
          .map((conversation) => InboxPreviewModel.fromJson(conversation))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }
}
