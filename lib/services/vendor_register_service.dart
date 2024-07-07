import 'package:flutter/material.dart';

class VendorRegisterService extends ChangeNotifier {
  bool _loading = false;

  bool isLoading() => _loading;

  void _toggleLoading() {
    _loading = !_loading;
    notifyListeners();
  }

  Future<void> registerVendor() async {
    _toggleLoading();

    try {
      throw Exception('Unimplemented');
    } catch (e) {
      rethrow;
    } finally {
      _toggleLoading();
    }
  }
}
