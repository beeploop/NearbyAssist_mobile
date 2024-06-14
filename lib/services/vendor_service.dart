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
import 'package:nearby_assist/services/request/authenticated_request.dart';

class VendorService extends ChangeNotifier {
  bool _loading = false;
  VendorModel? _vendor;
  ServiceDetailModel? _serviceInfo;

  bool isLoading() => _loading;

  void _toggleLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  Future<List<MyService>> fetchVendorServices() async {
    final user = getIt.get<AuthModel>().getUser();

    if (user == null) {
      return [];
    }

    try {
      final tokens = getIt.get<AuthModel>().getUserTokens();
      if (tokens == null) {
        throw Exception('Error fetching user tokens');
      }

      final endpoint = '/backend/v1/public/services/vendor/${user.userId}';
      final request = AuthenticatedRequest<Map<String, dynamic>>();
      final response = await request.request(endpoint, "GET");

      List<MyService> services = [];
      for (var service in response['services']) {
        final s = MyService.fromJson(service);
        services.add(s);
      }
      return services;
    } catch (e) {
      print('error fetching vendor services: $e');
      return [];
    }
  }

  Future<void> fetchServiceInfo(String id) async {
    _toggleLoading(true);

    try {
      final tokens = getIt.get<AuthModel>().getUserTokens();
      if (tokens == null) {
        throw Exception('Error fetching user tokens');
      }

      final endpoint = '/backend/v1/public/services/$id';
      final request = AuthenticatedRequest<Map<String, dynamic>>();
      final response = await request.request(endpoint, "GET");

      final countPerRating =
          CountPerRatingModel.fromJson(response['countPerRating']);
      final serviceInfo = ServiceInfoModel.fromJson(response['serviceInfo']);
      final vendorInfo = VendorInfoModel.fromJson(response['vendorInfo']);

      List<ServiceImageModel> serviceImages = [];
      for (var image in response['serviceImages']) {
        final s = ServiceImageModel.fromJson(image);
        serviceImages.add(s);
      }

      final serviceDetails = ServiceDetailModel(
        countPerRating: countPerRating,
        serviceInfo: serviceInfo,
        vendorInfo: vendorInfo,
        serviceImages: serviceImages,
      );

      _serviceInfo = serviceDetails;
    } catch (e) {
      debugPrint('error fetching vendor data: $e');
      _serviceInfo = null;
    }

    _toggleLoading(false);
    notifyListeners();
  }

  Future<bool?> checkVendorStatus() async {
    final user = getIt.get<AuthModel>().getUser();

    if (user == null) {
      return false;
    }

    try {
      final tokens = getIt.get<AuthModel>().getUserTokens();
      if (tokens == null) {
        throw Exception('Error fetching user tokens');
      }

      final endpoint = '/backend/v1/public/vendors/${user.userId}';
      final request = AuthenticatedRequest<Map<String, dynamic>>();
      final response = await request.request(endpoint, "GET");
      if (response == null) {
        throw Exception('Error fetching vendor status');
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
