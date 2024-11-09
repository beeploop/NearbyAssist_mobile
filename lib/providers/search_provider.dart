import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/search_result_model.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/services/search_service.dart';

class SearchProvider extends ChangeNotifier {
  final _api = SearchService();
  List<SearchResultModel> _results = [];
  final Map<String, DetailedServiceModel> _detail = {};
  final Map<String, List<List<num>>> _routes = {};
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

  bool hasRoute(String id) {
    return _routes.containsKey(id);
  }

  List<List<num>> getRoute(String id) {
    return _routes[id]!;
  }

  Future<void> search() async {
    _searching = true;
    notifyListeners();

    try {
      if (_tags.isEmpty) {
        throw 'Empty tags';
      }

      final userPos = await LocationService().getLocation();

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

  Future<List<List<num>>> fetchRoute(String id) async {
    try {
      final route = await _api.getRouteToService(id);
      _routes[id] = route;
      notifyListeners();

      return route;
    } catch (error) {
      logger.log('Error fetching route of service with id: $id');
      rethrow;
    }
  }
}
