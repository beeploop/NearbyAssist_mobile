import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/recommendation_model.dart';
import 'package:nearby_assist/services/recommendation_service.dart';

class RecommendationProvider extends ChangeNotifier {
  List<String> _popularSearches = [];
  List<RecommendationModel> _recommendations = [];
  bool _hasFetched = false;

  List<String> get popularSearches => _popularSearches;
  List<RecommendationModel> get recommendations => _recommendations;

  Future<void> fetchRecommendations() async {
    try {
      if (_hasFetched) return;
      _hasFetched = true;

      final svc = RecommendationService();
      final response = await svc.fetchRecommendations();

      _recommendations = (response['services'] as List)
          .map((recommendation) => RecommendationModel.fromJson(recommendation))
          .toList();

      _popularSearches = List<String>.from(
        (response['searches'] as List).map((item) => item),
      );

      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }
}
