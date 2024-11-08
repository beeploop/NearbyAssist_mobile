import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/search_result_model.dart';

class ServicesProvider extends ChangeNotifier {
  final List<SearchResultModel> _services = [];

  List<SearchResultModel> get services => _services;

  void add(SearchResultModel service) {
    _services.add(service);
    notifyListeners();
  }

  void replaceAll(List<SearchResultModel> services) {
    _services.clear();
    _services.addAll(services);
    notifyListeners();
  }

  SearchResultModel getById(String id) {
    return _services.firstWhere((service) => service.id == id);
  }
}
