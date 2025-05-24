import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoint {
  String _baseUrl;
  String _wsUrl;

  ApiEndpoint({required String baseUrl, required String wsUrl})
      : _baseUrl = baseUrl,
        _wsUrl = wsUrl;

  factory ApiEndpoint.fromEnv() {
    final baseUrl = dotenv.get('API_URL', fallback: 'http://localhost:3000');
    final wsUrl = dotenv.get('WS_URL', fallback: 'ws://localhost:3000');
    return ApiEndpoint(baseUrl: baseUrl, wsUrl: wsUrl);
  }

  void changeURL(String url) {
    const http = "http://";
    const https = "https://";

    if (url.startsWith(http)) {
      final addr = url.substring(http.length);
      _baseUrl = http + addr;
      _wsUrl = 'ws://$addr';
    } else if (url.startsWith(https)) {
      final addr = url.substring(https.length);
      _baseUrl = https + addr;
      _wsUrl = 'wss://$addr';
    }
  }

  String get baseUrl => _baseUrl;

  // Resource URL
  String get resource => '$_baseUrl/api/v1/resource';
  String get publicResource => '$_baseUrl/api/v1/resource/public';

  // Health check
  String get healthcheck => '$_baseUrl/api/v1/health/protected';

  String get reverseGeocoding => 'https://nominatim.openstreetmap.org/reverse';

  // Auth Routes
  String get login => '$_baseUrl/api/v1/auth/login';
  String get register => '$_baseUrl/api/v1/auth/register';
  String get logout => '$_baseUrl/api/v1/auth/logout';
  String get refresh => '$_baseUrl/api/v1/auth/refresh';

  String get saveKeys => '$_baseUrl/api/v1/e2ee';
  String get getKeys => '$_baseUrl/api/v1/e2ee/keys';
  String get getPublicKey => '$_baseUrl/api/v1/e2ee/key';

  String get me => '$_baseUrl/api/v1/user';
  String get getUser => '$_baseUrl/api/v1/user';
  String get addSocial => '$_baseUrl/api/v1/user/socials';
  String get deleteSocial => '$_baseUrl/api/v1/user/socials';
  String get addExpertise => '$_baseUrl/api/v1/user/addExpertise';
  String get udpateDBL => '$_baseUrl/api/v1/user/dbl';
  String get changeAddress => '$_baseUrl/api/v1/user/address';

  String get privacyPolicy => '$_baseUrl/privacy_policy';
  String get termsAndConditions => '$_baseUrl/terms_and_conditions';

  String get verifyAccount => '$_baseUrl/api/v1/user/verify';
  String get vendorApplication => '$_baseUrl/api/v1/applications';

  String get search => '$_baseUrl/api/v1/services/search';
  String get serviceDetails => '$_baseUrl/api/v1/services';
  String get findRoute => '$_baseUrl/api/v1/services/route';

  String get websocket => '$_wsUrl/ws';
  String get conversations => '$_baseUrl/api/v1/chat/conversations';
  String get getMessages => '$_baseUrl/api/v1/chat/messages';
  String get sendMessage => '$_baseUrl/api/v1/chat/send';
  String get markSeen => '$_baseUrl/api/v1/chat/markSeen';

  String get vendor => '$_baseUrl/api/v1/vendors';
  String get vendorServices => '$_baseUrl/api/v1/vendors/services';

  String get addService => '$_baseUrl/api/v1/services';
  String get updateService => '$_baseUrl/api/v1/services';

  String get addExtra => '$_baseUrl/api/v1/services/addExtra';
  String get editExtra => '$_baseUrl/api/v1/services/editExtra';
  String get deleteExtra => '$_baseUrl/api/v1/services/deleteExtra';

  String get addImage => '$_baseUrl/api/v1/services/addImage';
  String get deleteImage => '$_baseUrl/api/v1/services/deleteImage';

  String get disableService => '$_baseUrl/api/v1/services/disable';
  String get enableService => '$_baseUrl/api/v1/services/enable';

  String get savedServices => '$_baseUrl/api/v1/services/get-saved';
  String get saveService => '$_baseUrl/api/v1/services/save';
  String get unsaveService => '$_baseUrl/api/v1/services/unsave';

  String get getReviews => '$_baseUrl/api/v1/services/reviews';
  String get reviewOnBooking => '$_baseUrl/api/v1/reviews/booking';

  String get createBooking => '$_baseUrl/api/v1/bookings';
  String get cancelBooking => '$_baseUrl/api/v1/bookings/cancel';
  String get acceptRequest => '$_baseUrl/api/v1/bookings/accept';
  String get rejectRequest => '$_baseUrl/api/v1/bookings/reject';
  String get completeBooking => '$_baseUrl/api/v1/bookings/complete';
  String get rescheduleBooking => '$_baseUrl/api/v1/bookings/reschedule';
  String get toReviews => '$_baseUrl/api/v1/bookings/toReview';
  String get postReview => '$_baseUrl/api/v1/reviews';
  String get getBooking => '$_baseUrl/api/v1/bookings';
  String get recent => '$_baseUrl/api/v1/bookings/recent';
  String get history => '$_baseUrl/api/v1/bookings/history';
  String get confirmed => '$_baseUrl/api/v1/bookings/confirmed';
  String get myRequests => '$_baseUrl/api/v1/bookings/mine';
  String get clientRequests => '$_baseUrl/api/v1/bookings/mine';

  String get expertiseList => '$_baseUrl/api/v1/tags/expertise';

  String get qrSignature => '$_baseUrl/api/v1/qr/generateSignature';
  String get qrVerifySignature => '$_baseUrl/api/v1/qr/verifySignature';

  String get getNotifications => '$_baseUrl/api/v1/notifications';
  String get readNotification => '$_baseUrl/api/v1/notifications';

  String get reportBug => '$_baseUrl/api/v1/complaints/system';
  String get reportUser => '$_baseUrl/api/v1/complaints/user';

  String get recommendations => '$_baseUrl/api/v1/recommendations';
}
