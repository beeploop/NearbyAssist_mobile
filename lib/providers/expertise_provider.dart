import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/expertise_model.dart';
import 'package:nearby_assist/models/tag_model.dart';
import 'package:nearby_assist/services/tag_service.dart';

class ExpertiseProvider extends ChangeNotifier {
  List<ExpertiseModel> _expertise = [];

  List<ExpertiseModel> get expertise => _expertise;

  List<TagModel> getTagsOfExpertise(String? expertiseId) {
    if (expertiseId == null) {
      return [];
    }

    final expertise =
        _expertise.firstWhere((element) => element.id == expertiseId);
    return expertise.tags;
  }

  Future<void> fetchExpertise() async {
    try {
      final service = TagService();
      final response = await service.getExpertiseWithTags();

      _expertise = response;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
