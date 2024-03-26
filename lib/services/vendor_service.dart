import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/my_service.dart';
import 'package:nearby_assist/model/service_detail_model.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:http/http.dart' as http;
import 'package:nearby_assist/model/vendor_model.dart';

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
    final server = getIt.get<SettingsModel>().getServerAddr();
    final user = getIt.get<AuthModel>().getUser();

    if (user == null) {
      return [];
    }

    try {
      final resp = await http.get(
        Uri.parse('$server/v1/services/owner/${user.userId}'),
      );

      if (resp.statusCode != 200) {
        throw HttpException(
          'Server responded with status code: ${resp.statusCode}',
        );
      }

      List<MyService> services = [];
      List json = jsonDecode(resp.body);
      for (var service in json) {
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

    final server = getIt.get<SettingsModel>().getServerAddr();
    try {
      final resp = await http.get(Uri.parse('$server/v1/services/$id'));

      if (resp.statusCode != 200) {
        throw HttpException(
          'Server responded with status code: ${resp.statusCode}',
        );
      }

      final response = jsonDecode(resp.body);
      ServiceDetailModel serviceInfo = ServiceDetailModel.fromJson(response);
      final reviewCountString = serviceInfo.reviewCountMap.toString();
      final reviewCountMap = parseReviewCount(reviewCountString);
      serviceInfo.reviewCountMap = reviewCountMap;

      _serviceInfo = serviceInfo;
    } catch (e) {
      debugPrint('error fetching vendor data: $e');
      _serviceInfo = null;
    }

    _toggleLoading(false);
    notifyListeners();
  }

  Future<bool?> checkVendorStatus() async {
    final server = getIt.get<SettingsModel>().getServerAddr();
    final user = getIt.get<AuthModel>().getUser();

    if (user == null) {
      return false;
    }

    try {
      final resp =
          await http.get(Uri.parse('$server/v1/vendors/${user.userId}'));

      if (resp.statusCode == 204) {
        return false;
      }

      if (resp.statusCode != 200) {
        throw HttpException(
          'Server responded with status code: ${resp.statusCode}',
        );
      }

      return true;
    } catch (e) {
      debugPrint('error fetching vendor data: $e');
      return null;
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

