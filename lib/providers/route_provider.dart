import 'package:flutter/foundation.dart';
import 'package:nearby_assist/services/search_service.dart';

class RouteProvider extends ChangeNotifier {
  final Map<String, List<List<num>>> _routes = {};

  Future<List<List<num>>> getRoute(String id) async {
    try {
      if (_routes.containsKey(id)) {
        return _routes[id]!;
      }

      final route = await SearchService().getRouteToService(id);
      if (route.isEmpty) {
        return Future.error('no route found');
      }

      _routes[id] = route;
      notifyListeners();

      return route;
    } catch (error) {
      rethrow;
    }
  }
}
