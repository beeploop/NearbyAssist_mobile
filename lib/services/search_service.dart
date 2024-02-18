import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/location_service.dart';

class SearchingService {
  String _searchTerm = '';

  Future<void> searchService(BuildContext context, String search) async {
    if (search.isEmpty) return;
    _searchTerm = search;

    // Get the user's location if not yet gotten
    final hasLocationPermission =
        await getIt.get<LocationService>().checkPermissions(context);
    if (hasLocationPermission == false) {
      return;
    }

    await getIt.get<LocationService>().getCurrentLocation();

    if (context.mounted) {
      context.goNamed('map');
    }
  }

  String lastSearch() => _searchTerm;
}
