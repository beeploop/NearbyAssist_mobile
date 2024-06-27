import 'dart:io';

import 'package:flutter/material.dart';

class VerifyIdentityService extends ChangeNotifier {
  bool _isLoading = false;

  bool isLoading() {
    return _isLoading;
  }

  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<VerifyIdentityResult> verifyIdentity({
    required String name,
    required String address,
    required String idType,
    required String idNumber,
    required File frontId,
    required File backId,
    required File face,
  }) async {
    try {
      toggleLoading();
      throw Exception('Not implemented');
    } catch (e) {
      debugPrint('Error verifying identity: $e');
      return VerifyIdentityResult(success: false, message: '$e');
    } finally {
      toggleLoading();
    }
  }
}

class VerifyIdentityResult {
  bool success;
  String message;

  VerifyIdentityResult({
    required this.success,
    required this.message,
  });
}
