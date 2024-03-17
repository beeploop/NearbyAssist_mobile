import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/service_detail_model.dart';
import 'package:nearby_assist/model/service_photos.dart';
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
