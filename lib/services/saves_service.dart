import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/services/api_service.dart';

class SavesService {
  Future<List<DetailedServiceModel>> getSaves() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.savedServices);

      return (response.data['saves'] as List).map((service) {
        return DetailedServiceModel.fromJson(service);
      }).toList();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> save(DetailedServiceModel service) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.post(
        endpoint.saveService,
        data: {'serviceId': service.service.id},
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> unsave(String serviceId) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.post(
        endpoint.unsaveService,
        data: {'serviceId': serviceId},
      );
    } catch (error) {
      rethrow;
    }
  }
}
