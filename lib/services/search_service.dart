import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchingService {
  String _searchTerm = '';

  Future<void> searchService(BuildContext context, String search) async {
    if (search.isEmpty) return;

    _searchTerm = search;

    context.goNamed('map');
  }

  String lastSearch() => _searchTerm;
}
