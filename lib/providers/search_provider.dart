import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/search_result_model.dart';

class SearchProvider extends ChangeNotifier {
  final List<SearchResultModel> _results = [];
  final List<String> _tags = [];
  bool _isSearching = false;

  List<SearchResultModel> get results => _results;
  List<String> get tags => _tags;
  bool get isSearching => _isSearching;

  set searching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  void setTags(List<String> tags) {
    _tags.clear();
    _tags.addAll(tags);
    notifyListeners();
  }

  void replaceResults(List<SearchResultModel> results) {
    _results.clear();
    _results.addAll(results);
    notifyListeners();
  }

  SearchResultModel getById(String id) {
    return _results.firstWhere((service) => service.id == id);
  }
}
