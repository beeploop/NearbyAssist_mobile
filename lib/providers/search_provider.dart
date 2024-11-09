import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/search_result_model.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/services/search_service.dart';

class SearchProvider extends ChangeNotifier {
  final _api = SearchService();
  List<SearchResultModel> _results = [];
  final Map<String, DetailedServiceModel> _detail = {};
  List<String> _tags = [];
  bool _searching = false;

  List<SearchResultModel> get results => _results;
  List<String> get tags => _tags;
  bool get isSearching => _searching;

  void updateTags(List<String> tags) {
    _tags = tags;
    notifyListeners();
  }

  bool hasDetails(String id) {
    return _detail.containsKey(id);
  }

  DetailedServiceModel getDetails(String id) {
    return _detail[id]!;
  }

  Future<void> search(Position userPos) async {
    _searching = true;
    notifyListeners();

    try {
      if (_tags.isEmpty) {
        throw 'Empty tags';
      }

      _results = await _api.findServices(userPos: userPos, tags: _tags);
      notifyListeners();
    } catch (error) {
      rethrow;
    } finally {
      _searching = false;
      notifyListeners();
    }
  }

  Future<DetailedServiceModel> fetchDetails(String id) async {
    try {
      final detail = await _api.getServiceDetails(id);
      _detail[id] = detail;
      notifyListeners();

      return detail;
    } catch (error) {
      logger.log('Error fetching details of service with id: $id');
      rethrow;
    }
  }
}

class DetailedServiceModel {
  final RatingCountModel ratingCount;
  final ServiceModel service;
  final VendorModel vendor;
  final List<ServiceImageModel> images;

  DetailedServiceModel({
    required this.ratingCount,
    required this.service,
    required this.vendor,
    required this.images,
  });

  factory DetailedServiceModel.fromJson(Map<String, dynamic> json) {
    return DetailedServiceModel(
      ratingCount: RatingCountModel.fromJson(json['countPerRating']),
      service: ServiceModel.fromJson(json['serviceInfo']),
      vendor: VendorModel.fromJson(json['vendorInfo']),
      images: (json['serviceImages'] as List)
          .map((image) => ServiceImageModel.fromJson(image))
          .toList(),
    );
  }
}

class RatingCountModel {
  final int five;
  final int four;
  final int three;
  final int two;
  final int one;

  RatingCountModel({
    required this.five,
    required this.four,
    required this.three,
    required this.two,
    required this.one,
  });

  factory RatingCountModel.fromJson(Map<String, dynamic> json) {
    return RatingCountModel(
      five: json['five'],
      four: json['four'],
      three: json['three'],
      two: json['two'],
      one: json['one'],
    );
  }
}

class VendorModel {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String job;

  VendorModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.job,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['vendorId'],
      name: json['vendor'],
      imageUrl: json['imageUrl'],
      rating: double.parse(json['rating']),
      job: json['job'],
    );
  }
}

class ServiceImageModel {
  final String id;
  final String url;

  ServiceImageModel({
    required this.id,
    required this.url,
  });

  factory ServiceImageModel.fromJson(Map<String, dynamic> json) {
    return ServiceImageModel(
      id: json['id'],
      url: json['url'],
    );
  }
}
