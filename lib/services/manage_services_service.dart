import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/add_extra_model.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/detailed_vendor_model.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/models/update_service_model.dart';
import 'package:nearby_assist/services/api_service.dart';

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
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw 'Duplicate service';
      }

      rethrow;
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
      rethrow;
    }
  }

  Future<DetailedServiceModel> getService(String id) async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get('${endpoint.serviceDetails}/$id');
      return DetailedServiceModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<DetailedVendorModel> fetchServices(String id) async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get('${endpoint.vendorServices}/$id');

      return DetailedVendorModel.fromJson(response.data);
    } catch (error) {
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
}
