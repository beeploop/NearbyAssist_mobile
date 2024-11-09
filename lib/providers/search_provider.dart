import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/search_result_model.dart';
import 'package:nearby_assist/services/search_service.dart';

class SearchProvider extends ChangeNotifier {
  final _api = SearchService();
  List<SearchResultModel> _results = [];
  final Map<String, DetailedServiceModel> _detail = {};
  List<String> _tags = [];
  bool _searching = false;

  List<SearchResultModel> get results => _results;
  List<String> get tags => _tags;
  bool get isSearching => _searching;

  void updateTags(List<String> tags) {
    _tags = tags;
    notifyListeners();
  }

  bool hasDetails(String id) {
    return _detail.containsKey(id);
  }

  DetailedServiceModel getDetails(String id) {
    return _detail[id]!;
  }

  Future<void> search(Position userPos) async {
    _searching = true;
    notifyListeners();

    try {
      if (_tags.isEmpty) {
        throw 'Empty tags';
      }

      _results = await _api.findServices(userPos: userPos, tags: _tags);
      notifyListeners();
    } catch (error) {
      rethrow;
    } finally {
      _searching = false;
      notifyListeners();
    }
  }

  Future<DetailedServiceModel> fetchDetails(String id) async {
    try {
      final detail = await _api.getServiceDetails(id);
      _detail[id] = detail;
      notifyListeners();

      return detail;
    } catch (error) {
      logger.log('Error fetching details of service with id: $id');
      rethrow;
    }
  }
}
