import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/add_extra_model.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/booking_qr_code_data.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/detailed_vendor_model.dart';
import 'package:nearby_assist/models/new_service.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/models/service_image_model.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/models/service_review_model.dart';
import 'package:nearby_assist/models/update_service_model.dart';
import 'package:nearby_assist/services/api_service.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:nearby_assist/services/image_resize_service.dart';

class ControlCenterService {
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

  Future<List<BookingModel>> fetchReceivedRequests() async {
    logger.logDebug('called fetchReceivedRequests');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(
        endpoint.clientRequests,
        queryParameters: {'filter': 'received'},
      );

      return (response.data['bookings'] as List)
          .map((booking) => BookingModel.fromJson(booking))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<List<BookingModel>> fetchConfirmed() async {
    logger.logDebug('called fetchConfirmed');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(
        endpoint.confirmed,
        queryParameters: {'filter': 'vendor'},
      );

      return (response.data['bookings'] as List)
          .map((booking) => BookingModel.fromJson(booking))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<List<BookingModel>> fetchHistory() async {
    logger.logDebug('called fetchHistory');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(
        endpoint.history,
        queryParameters: {'filter': 'vendor'},
      );

      return (response.data['history'] as List)
          .map((booking) => BookingModel.fromJson(booking))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<ServiceModel> createService(NewService service) async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.post(
        endpoint.addService,
        data: service.toJson(),
      );

      final data = DetailedServiceModel.fromJson(response.data['service']);
      return data.service;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateService(UpdateServiceModel updated) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.put(endpoint.updateService, data: updated.toJson());
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> resubmit(String serviceId) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.put('${endpoint.resubmitService}/$serviceId');
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

  Future<ServiceImageModel> uploadImage(
      String serviceId, Uint8List bytes) async {
    try {
      final data = FormData.fromMap({
        'files': [
          MultipartFile.fromBytes(
            await compute(ImageResizeService.resize, bytes),
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

  Future<void> deleteImage(String imageId) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.delete('${endpoint.deleteImage}/$imageId');
    } catch (error) {
      rethrow;
    }
  }

  Future<void> disableService(String serviceId) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.post('${endpoint.disableService}/$serviceId');
    } catch (error) {
      rethrow;
    }
  }

  Future<void> enableService(String serviceId) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.post('${endpoint.enableService}/$serviceId');
    } catch (error) {
      rethrow;
    }
  }

  Future<void> acceptRequest(
      String id, String scheduleStart, String scheduleEnd) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.put(
        endpoint.acceptRequest,
        data: {
          'bookingId': id,
          'scheduleStart': scheduleStart,
          'scheduleEnd': scheduleEnd,
        },
      );
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> rejectRequest(String id, String reason) async {
    logger.logDebug('called rejectRequest');

    try {
      final api = ApiService.authenticated();
      await api.dio.put(
        endpoint.rejectRequest,
        data: {'bookingId': id, 'reason': reason},
      );
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> completeBooking(BookingQrCodeData data) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.post(
        endpoint.qrVerifySignature,
        data: data.toJson(),
      );

      await api.dio.post('${endpoint.completeBooking}/${data.bookingId}');
    } catch (error) {
      rethrow;
    }
  }

  Future<void> reschedule(
      String bookingId, String scheduleStart, String scheduleEnd) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.put(
        endpoint.rescheduleBooking,
        data: {
          'bookingId': bookingId,
          'scheduleStart': scheduleStart,
          'scheduleEnd': scheduleEnd,
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> cancel(String bookingId, String reason) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.put(
        endpoint.cancelBooking,
        data: {'bookingId': bookingId, 'reason': reason},
        queryParameters: {'actor': 'vendor'},
      );
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<List<ServiceReviewModel>> getReviews(String serviceId) async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get('${endpoint.getReviews}/$serviceId');

      return (response.data['reviews'] as List)
          .map((review) => ServiceReviewModel.fromJson(review))
          .toList();
    } catch (error) {
      rethrow;
    }
  }

  Future<ServiceReviewModel> getClientReviewOnBooking(
      String clientId, String bookingId) async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(
        endpoint.reviewOnBooking,
        queryParameters: {'userId': clientId, 'bookingId': bookingId},
      );

      return ServiceReviewModel.fromJson(response.data['review']);
    } catch (error) {
      rethrow;
    }
  }
}
