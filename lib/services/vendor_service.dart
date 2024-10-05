import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/count_per_rating_model.dart';
import 'package:nearby_assist/model/my_service.dart';
import 'package:nearby_assist/model/service_detail_model.dart';
import 'package:nearby_assist/model/service_image_model.dart';
import 'package:nearby_assist/model/service_info_model.dart';
import 'package:nearby_assist/model/vendor_info_model.dart';
import 'package:nearby_assist/model/vendor_model.dart';
import 'package:nearby_assist/request/dio_request.dart';
import 'package:nearby_assist/services/logger_service.dart';

class VendorService extends ChangeNotifier {
  bool _loading = false;
  VendorModel? _vendor;
  final Map<String, ServiceDetailModel> _serviceInfoCache = {};

  bool isLoading() => _loading;

  void _toggleLoading() {
    _loading = !_loading;
    notifyListeners();
  }

  Future<ServiceDetailModel> getServiceInfo(String id) async {
    try {
      if (!_serviceInfoCache.containsKey(id)) {
        ConsoleLogger().log("Service info cache miss");

        final response = await _fetchServiceInfo(id);
        _serviceInfoCache[id] = response;

        return response;
      }

      ConsoleLogger().log("Service info cache hit");
      return _serviceInfoCache[id]!;
    } catch (err) {
      rethrow;
    }
  }

  Future<List<MyService>> fetchVendorServices() async {
    try {
      final user = getIt.get<AuthModel>().getUser();
      final url = '/api/v1/services/vendor/${user.id}';

      final request = DioRequest();
      final response = await request.get(url);

      List data = response.data['services'];
      return data.map((service) {
        return MyService.fromJson(service);
      }).toList();
    } catch (err) {
      rethrow;
    }
  }

  Future<ServiceDetailModel> _fetchServiceInfo(String id) async {
    _toggleLoading();

    try {
      final url = '/api/v1/services/$id';
      final request = DioRequest();
      final response = await request.get(url);

      final countPerRating = CountPerRatingModel.fromJson(
        response.data['countPerRating'],
      );
      final serviceInfo = ServiceInfoModel.fromJson(
        response.data['serviceInfo'],
      );
      final vendorInfo = VendorInfoModel.fromJson(
        response.data['vendorInfo'],
      );

      List<ServiceImageModel> serviceImages = [
        ...response.data['serviceImages'].map((image) {
          return ServiceImageModel.fromJson(image);
        })
      ];

      return ServiceDetailModel(
        countPerRating: countPerRating,
        serviceInfo: serviceInfo,
        vendorInfo: vendorInfo,
        serviceImages: serviceImages,
      );
    } catch (e) {
      ConsoleLogger().log('error fetching vendor data: $e');
      rethrow;
    } finally {
      _toggleLoading();
    }
  }

  Future<bool> checkVendorStatus() async {
    try {
      final user = getIt.get<AuthModel>().getUser();
      final url = '/api/v1/vendors/${user.id}';

      final request = DioRequest();
      final response = await request.get(url);

      if (response.data["vendor"] == null) {
        return false;
      }

      if (response.data.containsKey('vendor') == false) {
        return false;
      }

      return true;
    } catch (err) {
      if (err.toString().contains('404')) {
        return false;
      }

      rethrow;
    }
  }

  VendorModel? getVendor() {
    return _vendor;
  }

  Map<int, int> parseReviewCount(String reviewCount) {
    reviewCount = reviewCount.replaceAll('{', '').replaceAll('}', '');

    final reviewCountMap = <int, int>{};
    final reviewCountList = reviewCount.split(',');

    for (String pair in reviewCountList) {
      pair.trim();
      List<String> valuePair = pair.split(':');

      int key = int.parse(valuePair[0].trim());
      int value = int.parse(valuePair[1].trim());

      reviewCountMap[key] = value;
    }

    return reviewCountMap;
  }
}
