import 'dart:io';
import 'package:flutter/foundation.dart';

class VendorRegisterService extends ChangeNotifier {
  bool _loading = false;

  bool isLoading() => _loading;

  void _toggleLoading() {
    _loading = !_loading;
    notifyListeners();
  }

  Future<void> registerVendor({
    required String job,
    required File policeClearance,
    required File serviceCertificate,
  }) async {
    _toggleLoading();

    try {
      throw Exception('Unimplemented');
    } catch (e) {
      if (kDebugMode) {
        print('===== Error: $e');
      }
    } finally {
      _toggleLoading();
    }
  }
}
