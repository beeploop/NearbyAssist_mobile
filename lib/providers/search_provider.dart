import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearby_assist/models/search_result_model.dart';
import 'package:nearby_assist/services/search_service.dart';

class SearchProvider extends ChangeNotifier {
  final _api = SearchService();
  List<SearchResultModel> _results = [];
  List<String> _tags = [];
  bool _searching = false;

  List<SearchResultModel> get results => _results;
  List<String> get tags => _tags;
  bool get isSearching => _searching;

  void updateTags(List<String> tags) {
    _tags = tags;
    notifyListeners();
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
}
