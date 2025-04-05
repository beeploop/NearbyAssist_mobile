import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/add_extra_model.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/detailed_vendor_model.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/models/service_image_model.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/models/update_service_model.dart';
import 'package:nearby_assist/services/api_service.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

class ManageServicesService {
  Future<ServiceModel> add(ServiceModel service) async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.post(
        endpoint.addService,
        data: service.toJson(),
      );

      final id = response.data['service'];
      return service.copyWithNewId(id);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> update(UpdateServiceModel updated) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.put(
        '${endpoint.updateService}/${updated.id}',
        data: updated.toJson(),
      );
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<DetailedServiceModel> getService(String id) async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get('${endpoint.serviceDetails}/$id');
      return DetailedServiceModel.fromJson(response.data['detail']);
    } catch (error) {
      rethrow;
    }
  }

  Future<DetailedVendorModel> fetchServices(String vendorId) async {
    try {
      final api = ApiService.authenticated();
      final response =
          await api.dio.get('${endpoint.vendorServices}/$vendorId');

      return DetailedVendorModel.fromJson(response.data);
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<ServiceExtraModel> addExtra(AddExtraModel extra) async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.post(
        endpoint.addExtra,
        data: extra.toJson(),
      );

      final extraId = response.data['extraId'] as String;

      return ServiceExtraModel(
        id: extraId,
        title: extra.title,
        description: extra.description,
        price: extra.price,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateExtra(ServiceExtraModel extra) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.put(endpoint.editExtra, data: extra.toJson());
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteExtra(String id) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.delete('${endpoint.deleteExtra}/$id');
    } catch (error) {
      rethrow;
    }
  }

  Future<ServiceImageModel> uploadServiceImage(
      String serviceId, Uint8List bytes) async {
    try {
      final data = FormData.fromMap({
        'files': [
          MultipartFile.fromBytes(
            bytes,
            filename: 'image',
            contentType: MediaType('image', 'jpeg'),
          ),
        ],
      });

      final api = ApiService.authenticated();
      final response = await api.dio.post(
        '${endpoint.addImage}/$serviceId',
        data: data,
      );

      return ServiceImageModel(
        id: response.data['imageId'],
        url: response.data['url'],
      );
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> deleteServiceImage(String imageId) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.delete('${endpoint.deleteImage}/$imageId');
    } catch (error) {
      rethrow;
    }
  }
}
