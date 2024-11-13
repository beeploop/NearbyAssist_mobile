import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/vendor_model.dart';

class VendorProvider extends ChangeNotifier {
  final Map<String, VendorModel> _vendors = {};

  Future<VendorModel> getVendor(String id) async {
    try {
      if (_vendors.containsKey(id)) {
        return _vendors[id]!;
      }

      return Future.error('Vendor not found');
    } catch (error) {
      rethrow;
    }
  }
}
