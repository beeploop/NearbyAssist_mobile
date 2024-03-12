import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:http/http.dart' as http;

class VendorService extends ChangeNotifier {
  bool _loading = false;
  String _vendor = '';

  bool isLoading() => _loading;

  void _toggleLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  Future<void> _fetchVendor(String id) async {
    _toggleLoading(true);

    _vendor = 'test vendor data';
    final server = getIt.get<SettingsModel>().getServerAddr();
    try {
      final resp = await http.get(Uri.parse('$server/v1/vendors/$id'));

      if (resp.statusCode != 200) {
        throw HttpException(
          'Server responded with status code: ${resp.statusCode}',
        );
      }

      debugPrint('response: ${resp.body}');
    } catch (e) {
      debugPrint('$e');
    }

    _toggleLoading(false);
    notifyListeners();
  }

  Future<String> getVendor(String vendorId) async {
    await _fetchVendor(vendorId);
    return _vendor;
  }
}
