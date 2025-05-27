import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/search_result_model.dart';
import 'package:nearby_assist/pages/search/widget/service_sorting_method.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/services/search_service.dart';

class SearchProvider extends ChangeNotifier {
  bool _boundless = false;
  double _radius = 400;
  bool _searching = false;
  String _latestSearchTerm = '';
  ServiceSortingMethod _sortingMethod = ServiceSortingMethod.suggestibility;

  bool get boundless => _boundless;
  double get radius => _radius;
  ServiceSortingMethod get sortingMethod => _sortingMethod;
  bool get searching => _searching;
  String get latestSearchTerm => _latestSearchTerm;

  void toggleBoundless() {
    _boundless = !_boundless;
    notifyListeners();
  }

  void updateRadius(double value) {
    _radius = value;
    notifyListeners();
  }

  void changeSortingMethod(ServiceSortingMethod method) {
    _sortingMethod = method;
    notifyListeners();
  }

  Future<List<SearchResultModel>> search(String searchTerm) async {
    try {
      _searching = true;
      _latestSearchTerm = searchTerm;
      notifyListeners();

      if (searchTerm.isEmpty) {
        throw 'Invalid term';
      }

      final queries = searchTerm
          .trim()
          .split(",")
          .map((term) => term.trim())
          .where((term) => term.isNotEmpty)
          .toList();

      final location = await LocationService().getLocation();

      return await SearchService().findServices(
        location: location,
        tags: queries,
        radius: _radius,
        boundless: _boundless,
      );
    } catch (error) {
      rethrow;
    } finally {
      _searching = false;
      notifyListeners();
    }
  }
}
