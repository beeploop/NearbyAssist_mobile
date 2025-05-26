import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/add_extra_model.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/booking_qr_code_data.dart';
import 'package:nearby_assist/models/new_service.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/models/service_review_model.dart';
import 'package:nearby_assist/models/update_service_model.dart';
import 'package:nearby_assist/services/control_center_service.dart';

class ControlCenterProvider extends ChangeNotifier {
  List<ServiceModel> _services = [];
  List<BookingModel> _requests = [];
  List<BookingModel> _schedules = [];
  List<BookingModel> _history = [];

  List<ServiceModel> get services => _services;
  List<BookingModel> get requests => _requests;
  List<BookingModel> get schedules => _schedules;
  List<BookingModel> get history => _history;

  Future<void> fetchServices(String vendorId) async {
    try {
      final result = await ControlCenterService().fetchServices(vendorId);
      _services = result.services;
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> fetchRequests() async {
    try {
      final response = await ControlCenterService().fetchReceivedRequests();
      _requests = response;
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> fetchSchedules() async {
    try {
      final response = await ControlCenterService().fetchConfirmed();
      _schedules = response;
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> fetchHistory() async {
    try {
      final response = await ControlCenterService().fetchHistory();
      _history = response;
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

  Future<void> addService(NewService service) async {
    try {
      final response = await ControlCenterService().createService(service);
      _services = [response, ..._services];
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

      final index = _services.indexWhere((service) => service.id == updated.id);
      if (index == -1) return;

      _services = _services.map((service) {
        if (service.id == updated.id) {
          return service.copyWith(
            title: updated.title,
            description: updated.description,
            price: updated.price,
            pricingType: updated.pricingType,
            tags: updated.tags,
          );
        }
        return service;
      }).toList();

      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> resubmit(String serviceId) async {
    try {
      await ControlCenterService().resubmit(serviceId);

      final index = _services.indexWhere((service) => service.id == serviceId);
      if (index == -1) return;

      final service = _services[index].copyWith(
        status: ServiceStatus.underReview,
      );

      _services = List.of(_services)..removeAt(index);
      _services = [service, ..._services];

      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> addExtra(AddExtraModel newExtra) async {
    try {
      final response = await ControlCenterService().addExtra(newExtra);

      _services = _services.map((service) {
        if (service.id == newExtra.serviceId) {
          return service.copyWith(extras: [...service.extras, response]);
        }
        return service;
      }).toList();

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
      if (index == -1) return;

      final service = _services[index];
      final newExtras =
          service.extras.where((extra) => extra.id != extraId).toList();

      final updatedService = service.copyWith(extras: newExtras);
      _services = [
        ..._services.sublist(0, index),
        updatedService,
        ..._services.sublist(index + 1)
      ];

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
      if (index == -1) return;

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

  Future<void> disableService(String serviceId) async {
    try {
      await ControlCenterService().disableService(serviceId);

      final index = _services.indexWhere((service) => service.id == serviceId);
      if (index == -1) return;
      _services[index].disabled = true;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> enableService(String serviceId) async {
    try {
      await ControlCenterService().enableService(serviceId);

      final index = _services.indexWhere((service) => service.id == serviceId);
      if (index == -1) return;
      _services[index].disabled = false;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> confirm(
      String id, String scheduleStart, String scheduleEnd) async {
    try {
      await ControlCenterService().acceptRequest(
        id,
        scheduleStart,
        scheduleEnd,
      );

      final index = _requests.indexWhere((request) => request.id == id);
      if (index == -1) return;

      final confirmedBooking = _requests[index].copyWith(
        scheduleStart: DateTime.parse(scheduleStart),
        scheduleEnd: DateTime.parse(scheduleEnd),
      );

      _requests = List.of(_requests)..removeAt(index);
      _schedules = [confirmedBooking, ..._schedules];

      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> reject(String id, String reason) async {
    try {
      await ControlCenterService().rejectRequest(id, reason);

      final index = _requests.indexWhere((request) => request.id == id);
      if (index == -1) return;

      final rejectedBooking = _requests[index].copyWith(
        status: BookingStatus.rejected,
        cancelReason: reason,
      );

      _requests = List.of(_requests)..removeAt(index);
      _history = [rejectedBooking, ..._history];

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> complete(BookingQrCodeData data) async {
    try {
      await ControlCenterService().completeBooking(data);

      final index =
          _schedules.indexWhere((booking) => booking.id == data.bookingId);
      if (index == -1) return;

      final completedBooking = _schedules[index].copyWith(
        status: BookingStatus.done,
        updatedAt: DateTime.now(),
      );

      _schedules = List.of(_schedules)..removeAt(index);
      _history = [completedBooking, ..._history];

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> reschedule(
    String bookingId,
    String scheduleStart,
    String scheduleEnd,
  ) async {
    try {
      await ControlCenterService().reschedule(
        bookingId,
        scheduleStart,
        scheduleEnd,
      );

      final index = _schedules.indexWhere((booking) => booking.id == bookingId);
      if (index == -1) return;

      _schedules = _schedules.map((booking) {
        if (booking.id == bookingId) {
          return booking.copyWith(
            scheduleStart: DateTime.parse(scheduleStart),
            scheduleEnd: DateTime.parse(scheduleEnd),
          );
        }
        return booking;
      }).toList();

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> cancel(String bookingId, String reason) async {
    try {
      await ControlCenterService().cancel(bookingId, reason);

      final index = _schedules.indexWhere((booking) => booking.id == bookingId);
      if (index == -1) return;

      final cancelledBooking = _schedules[index].copyWith(
        status: BookingStatus.cancelled,
        cancelReason: reason,
      );

      _schedules = List.of(_schedules)..removeAt(index);
      _history = [cancelledBooking, ..._history];

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<List<ServiceReviewModel>> getReviews(String serviceId) async {
    try {
      return await ControlCenterService().getReviews(serviceId);
    } catch (error) {
      rethrow;
    }
  }

  Future<ServiceReviewModel> getClientReviewOnBooking(
    String clientId,
    String bookingId,
  ) async {
    try {
      return await ControlCenterService().getClientReviewOnBooking(
        clientId,
        bookingId,
      );
    } catch (error) {
      rethrow;
    }
  }

  void receivedRequest(BookingModel request) {
    _requests = [request, ..._requests];
    notifyListeners();
  }

  void cancelledRequest(String bookingId, String reason) {
    final index = _requests.indexWhere((req) => req.id == bookingId);
    if (index == -1) return;

    final cancelledBooking = _requests[index].copyWith(
      status: BookingStatus.cancelled,
      updatedAt: DateTime.now(),
      cancelReason: reason,
      cancelledById: _requests[index].client.id,
    );

    _requests = List.of(_requests)..removeAt(index);
    _history = [cancelledBooking, ..._history];

    notifyListeners();
  }

  void cancelledConfirmed(String bookingId, String reason) {
    final index = _schedules.indexWhere((req) => req.id == bookingId);
    if (index == -1) return;

    final cancelledBooking = _schedules[index].copyWith(
      status: BookingStatus.cancelled,
      updatedAt: DateTime.now(),
      cancelReason: reason,
      cancelledById: _schedules[index].client.id,
    );

    _schedules = List.of(_schedules)..removeAt(index);
    _history = [cancelledBooking, ..._history];

    notifyListeners();
  }

  void serviceAccepted(String serviceId) {
    final index = _services.indexWhere((service) => service.id == serviceId);
    if (index == -1) return;

    final acceptedService = _services[index].copyWith(
      status: ServiceStatus.accepted,
    );

    _services = List.of(_services)..removeAt(index);
    _services = [acceptedService, ..._services];
    notifyListeners();
  }

  void serviceRejected(String serviceId, String reason) {
    final index = _services.indexWhere((service) => service.id == serviceId);
    if (index == -1) return;

    final acceptedService = _services[index].copyWith(
      status: ServiceStatus.rejected,
      rejectReason: reason,
    );

    _services = List.of(_services)..removeAt(index);
    _services = [acceptedService, ..._services];
    notifyListeners();
  }
}
