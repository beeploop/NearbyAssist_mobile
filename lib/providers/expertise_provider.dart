import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/expertise_model.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/services/secure_storage.dart';

class ExpertiseProvider extends ChangeNotifier {
  List<ExpertiseModel> _expertise = [];
  List<String> _tags = [];

  List<ExpertiseModel> get expertise => _expertise;
  List<String> get tags => _tags;

  Future<void> fetchExpertise() async {
    try {
      final api = ApiService.unauthenticated();
      final response = await api.dio.get(endpoint.expertiseList);

      final list = (response.data['expertise'] as List)
          .map((expertise) => ExpertiseModel.fromJson(expertise))
          .toList();

      _expertise = list;
      await SecureStorage().saveExpertise(list);

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchTags() async {
    try {
      final api = ApiService.unauthenticated();
      final response = await api.dio.get(endpoint.tagsList);

      final list =
          (response.data['tags'] as List).map((tag) => tag.toString()).toList();

      _tags = list;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> tryLoadLocal() async {
    try {
      final expertises = await SecureStorage().getExpertise();
      _expertise = expertises;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
