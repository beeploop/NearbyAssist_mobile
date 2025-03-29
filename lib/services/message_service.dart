import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/conversation_model.dart';
import 'package:nearby_assist/models/message_model.dart';
import 'package:nearby_assist/services/api_service.dart';

class MessageService {
  Future<void> send(MessageModel message) async {
    logger.logDebug('called send in message_service.dart');

    try {
      final api = ApiService.authenticated();
      await api.dio.post(endpoint.sendMessage, data: message.toJson());
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<List<MessageModel>> fetchMessages(String recipeintId) async {
    logger.logDebug('called fetchMessages in message_service.dart');

    try {
      final api = ApiService.authenticated();
      final response =
          await api.dio.get('${endpoint.getMessages}/$recipeintId');

      return (response.data['messages'] as List)
          .map((message) => MessageModel.fromJson(message))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<List<ConversationModel>> fetchConversations() async {
    logger.logDebug('called fetchConversations in message_service.dart');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.conversations);

      return (response.data['conversations'] as List)
          .map((conversation) => ConversationModel.fromJson(conversation))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }
}
