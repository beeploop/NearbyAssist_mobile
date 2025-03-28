import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/detailed_vendor_model.dart';
import 'package:nearby_assist/services/api_service.dart';

class VendorProvider extends ChangeNotifier {
  final Map<String, DetailedVendorModel> _vendors = {};

  Future<DetailedVendorModel> getVendor(String vendorId) async {
    logger.logDebug('called getVendor in vendor_provider.dart');

    try {
      if (_vendors.containsKey(vendorId)) {
        return _vendors[vendorId]!;
      }

      final api = ApiService.authenticated();
      final response =
          await api.dio.get('${endpoint.vendorServices}/$vendorId');

      final data = DetailedVendorModel.fromJson(response.data);
      _vendors[vendorId] = data;

      return data;
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }
}
