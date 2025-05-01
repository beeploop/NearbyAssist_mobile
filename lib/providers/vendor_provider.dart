import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/detailed_vendor_model.dart';
import 'package:nearby_assist/services/vendor_service.dart';

class VendorProvider extends ChangeNotifier {
  Future<DetailedVendorModel> getVendor(String vendorId) async {
    try {
      final detail = await VendorService().getVendorFullDetail(vendorId);
      return detail;
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }
}
