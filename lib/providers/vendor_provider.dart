import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/detailed_vendor_model.dart';
import 'package:nearby_assist/services/api_service.dart';

class VendorProvider extends ChangeNotifier {
  Future<DetailedVendorModel> getVendor(String vendorId) async {
    try {
      final api = ApiService.authenticated();
      final response =
          await api.dio.get('${endpoint.vendorServices}/$vendorId');

      final data = DetailedVendorModel.fromJson(response.data);
      return data;
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }
}
