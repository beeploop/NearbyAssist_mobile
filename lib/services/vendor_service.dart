import 'package:flutter/material.dart';

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

    _toggleLoading(false);
    notifyListeners();
  }

  Future<String> getVendor(String vendorId) async {
    await _fetchVendor(vendorId);
    return _vendor;
  }
}
