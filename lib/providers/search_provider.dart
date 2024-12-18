import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/search_result_model.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/services/search_service.dart';

class SearchProvider extends ChangeNotifier {
  List<String> _queries = [];
  bool _searching = false;

  List<String> get queries => _queries;

  bool get searching => _searching;

  void setQueries(List<String> queries) {
    _queries = queries;
    notifyListeners();
  }

  Future<List<SearchResultModel>> search() async {
    try {
      if (_queries.isEmpty) {
        return Future.error('Select at least one tag');
      }

      _searching = true;
      notifyListeners();

      final location = await LocationService().getLocation();

      return await SearchService().findServices(
        location: location,
        tags: _queries,
      );
    } catch (error) {
      rethrow;
    } finally {
      _searching = false;
      notifyListeners();
    }
  }
}
