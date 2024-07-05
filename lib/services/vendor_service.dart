import 'package:flutter/material.dart';
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

class VendorService extends ChangeNotifier {
  bool _loading = false;
  VendorModel? _vendor;
  ServiceDetailModel? _serviceInfo;

  bool isLoading() => _loading;

  void _toggleLoading() {
    _loading = !_loading;
    notifyListeners();
  }

  Future<List<MyService>> fetchVendorServices() async {
    try {
      final user = getIt.get<AuthModel>().getUser();
      final url = '/backend/v1/public/services/vendor/${user.userId}';

      final request = DioRequest();
      final response = await request.get(url);

      List data = response.data['services'];
      return data.map((service) {
        return MyService.fromJson(service);
      }).toList();
    } catch (e) {
      debugPrint('error fetching vendor services: $e');
      return [];
    }
  }

  Future<ServiceDetailModel> fetchServiceInfo(String id) async {
    _toggleLoading();

    try {
      final url = '/backend/v1/public/services/$id';

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
      debugPrint('error fetching vendor data: $e');
      rethrow;
    } finally {
      _toggleLoading();
    }
  }

  Future<bool> checkVendorStatus() async {
    try {
      final user = getIt.get<AuthModel>().getUser();
      final url = '/backend/v1/public/vendors/${user.userId}';

      final request = DioRequest();
      final response = await request.get(url);

      if (response.data.containsKey('vendor') == false) {
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('error fetching vendor data: $e');
      return false;
    }
  }

  VendorModel? getVendor() {
    return _vendor;
  }

  ServiceDetailModel? getServiceInfo() {
    return _serviceInfo;
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
