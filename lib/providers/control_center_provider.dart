import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/add_extra_model.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/booking_qr_code_data.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/models/update_service_model.dart';
import 'package:nearby_assist/services/control_center_service.dart';

class ControlCenterProvider extends ChangeNotifier {
  final List<ServiceModel> _services = [];
  final List<BookingModel> _requests = [];
  final List<BookingModel> _schedules = [];
  final List<BookingModel> _history = [];

  List<ServiceModel> get services => _services;
  List<BookingModel> get requests => _requests;
  List<BookingModel> get schedules => _schedules;
  List<BookingModel> get history => _history;

  Future<void> fetchServices(String vendorId) async {
    try {
      final result = await ControlCenterService().fetchServices(vendorId);
      _services.clear();
      _services.addAll(result.services);
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> fetchRequests() async {
    try {
      final response = await ControlCenterService().fetchReceivedRequests();
      _requests.clear();
      _requests.addAll(response);
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> fetchSchedules() async {
    try {
      final response = await ControlCenterService().fetchConfirmed();
      _schedules.clear();
      _schedules.addAll(response);
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> fetchHistory() async {
    try {
      final response = await ControlCenterService().fetchHistory();
      _history.clear();
      _history.addAll(response);
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> fetchAll(String vendorId) async {
    try {
      await Future.wait([
        fetchServices(vendorId),
        fetchRequests(),
        fetchSchedules(),
        fetchHistory(),
      ]);
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> addService(ServiceModel service) async {
    try {
      final response = await ControlCenterService().createService(service);
      _services.add(response);
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> updateService(
      UpdateServiceModel updated, List<ServiceExtraModel> extras) async {
    try {
      await ControlCenterService().updateService(updated);

      final updatedService = ServiceModel(
        id: updated.id,
        vendorId: updated.vendorId,
        title: updated.title,
        description: updated.description,
        rate: updated.rate,
        tags: updated.tags,
        extras: extras,
        location: updated.location,
        images:
            _services.firstWhere((service) => service.id == updated.id).images,
      );

      _services.removeWhere((service) => service.id == updated.id);
      _services.add(updatedService);
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> addExtra(AddExtraModel newExtra) async {
    try {
      final response = await ControlCenterService().addExtra(newExtra);

      for (var service in _services) {
        if (service.id == newExtra.serviceId) {
          service.extras.add(response);
        }
      }
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> deleteExtra(String serviceId, String extraId) async {
    try {
      await ControlCenterService().deleteExtra(extraId);

      final index = _services.indexWhere((service) => service.id == serviceId);
      _services[index].extras.removeWhere((extra) => extra.id == extraId);
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> updateExtra(String serviceId, ServiceExtraModel updated) async {
    try {
      await ControlCenterService().updateExtra(updated);

      final index = _services.indexWhere((service) => service.id == serviceId);
      final updatedExtras = _services[index].extras.map((extra) {
        if (extra.id == updated.id) {
          return ServiceExtraModel(
            id: extra.id,
            title: updated.title,
            description: updated.description,
            price: updated.price,
          );
        }

        return extra;
      }).toList();

      _services[index].extras.clear();
      _services[index].extras.addAll(updatedExtras);
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> uploadImage(String serviceId, Uint8List bytes) async {
    try {
      final image = await ControlCenterService().uploadImage(serviceId, bytes);

      final index = _services.indexWhere((service) => service.id == serviceId);
      _services[index].images.add(image);
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> deleteImage(String serviceId, String imageId) async {
    try {
      await ControlCenterService().deleteImage(imageId);

      final index = _services.indexWhere((service) => service.id == serviceId);
      _services[index].images.retainWhere((image) => image.id != imageId);
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> confirm(String id, String schedule) async {
    try {
      await ControlCenterService().acceptRequest(id, schedule);

      final targetIdx = _requests.indexWhere((request) => request.id == id);
      final acceptedBooking = _requests.removeAt(targetIdx);
      _schedules.add(acceptedBooking.copyWithSchedule(schedule));
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> reject(String id, String reason) async {
    try {
      await ControlCenterService().rejectRequest(id, reason);

      final targetIdx = _requests.indexWhere((request) => request.id == id);
      final rejectedBooking = _requests.removeAt(targetIdx);
      _history.add(rejectedBooking.copyWithNewStatus(BookingStatus.rejected));
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> complete(BookingQrCodeData data) async {
    try {
      await ControlCenterService().completeBooking(data);
      _schedules.removeWhere((request) => request.id == data.bookingId);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
