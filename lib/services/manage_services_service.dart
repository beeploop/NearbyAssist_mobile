import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/detailed_vendor_model.dart';
import 'package:nearby_assist/models/service_model.dart';
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

  Future<void> edit(ServiceModel service) async {
    try {
      throw UnimplementedError();
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
}
