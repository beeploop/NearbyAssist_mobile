import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/count_per_rating_model.dart';
import 'package:nearby_assist/model/my_service.dart';
import 'package:nearby_assist/model/service_detail_model.dart';
import 'package:nearby_assist/model/service_image_model.dart';
import 'package:nearby_assist/model/service_info_model.dart';
import 'package:nearby_assist/model/vendor_info_model.dart';
import 'package:nearby_assist/request/dio_request.dart';
import 'package:nearby_assist/services/logger_service.dart';

class VendorService extends ChangeNotifier {
  bool _loading = false;
  final Map<String, ServiceDetailModel> _serviceInfoCache = {};
  final List<MyService> _myServicesCache = [];

  bool isLoading() => _loading;

  void _toggleLoading() {
    _loading = !_loading;
    notifyListeners();
  }

  List<MyService> getMySevices() => _myServicesCache;

  Future<List<MyService>> fetchMyServices({bool forceRefresh = false}) async {
    try {
      if (!forceRefresh) {
        return _myServicesCache;
      }

      final user = getIt.get<AuthModel>().getUser();
      final url = '/api/v1/services/vendor/${user.id}';

      final request = DioRequest();
      final response = await request.get(url);

      List data = response.data['services'];
      final services = data.map((service) {
        return MyService.fromJson(service);
      }).toList();

      _myServicesCache.clear();
      _myServicesCache.addAll(services);

      notifyListeners();
      return services;
    } catch (err) {
      rethrow;
    }
  }

  Future<ServiceDetailModel> getServiceInfo(
    String id, {
    bool toogleLoading = true,
  }) async {
    try {
      if (toogleLoading) {
        _toggleLoading();
      }

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
    } finally {
      if (toogleLoading) {
        _toggleLoading();
      }
    }
  }

  Future<ServiceDetailModel> _fetchServiceInfo(String id) async {
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

  Future<void> addService(MyService service) async {
    try {
      _toggleLoading();

      const url = "/api/v1/services";
      final request = DioRequest();
      final response = await request.post(
        url,
        service.toJson(),
        expectedStatus: HttpStatus.created,
      );

      final id = response.data["service"];
      service.id = id;
      _myServicesCache.add(service);

      notifyListeners();
    } catch (err) {
      if (err.toString().contains("409")) {
        throw Exception(
            "Service already added. Refresh service list to see udpated list");
      }
      rethrow;
    } finally {
      _toggleLoading();
    }
  }

  Future<void> updateService(MyService service) async {
    try {
      _toggleLoading();

      final url = "/api/v1/services/${service.id}";
      final request = DioRequest();
      await request.put(
        url,
        service.toJson(),
        expectedStatus: HttpStatus.noContent,
      );

      _serviceInfoCache.remove(service.id);
      _myServicesCache.remove(service.id);

      notifyListeners();
    } catch (err) {
      ConsoleLogger().log("Error updating service: $err");
      rethrow;
    } finally {
      _toggleLoading();
    }
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
