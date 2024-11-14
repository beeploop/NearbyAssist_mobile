import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/detailed_vendor_model.dart';
import 'package:nearby_assist/services/api_service.dart';

class VendorProvider extends ChangeNotifier {
  final Map<String, DetailedVendorModel> _vendors = {};

  Future<DetailedVendorModel> getVendor(String id) async {
    try {
      if (_vendors.containsKey(id)) {
        return _vendors[id]!;
      }

      final api = ApiService.authenticated();
      final response = await api.dio.get('${endpoint.vendorServices}/$id');

      final data = DetailedVendorModel.fromJson(response.data);
      _vendors[id] = data;

      return data;
    } catch (error) {
      logger.log('Error fetching vendor: $error');
      rethrow;
    }
  }
}
