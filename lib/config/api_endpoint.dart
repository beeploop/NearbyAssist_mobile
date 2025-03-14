import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoint {
  final String _baseUrl;
  final String _wsUrl;

  ApiEndpoint({required String baseUrl, required String wsUrl})
      : _baseUrl = baseUrl,
        _wsUrl = wsUrl;

  factory ApiEndpoint.fromEnv() {
    final baseUrl = dotenv.get('API_URL', fallback: 'http://localhost:3000');
    final wsUrl = dotenv.get('WS_URL', fallback: 'ws://localhost:3000');
    return ApiEndpoint(baseUrl: baseUrl, wsUrl: wsUrl);
  }

  String get baseUrl => _baseUrl;

  // Resource URL
  String get resource => '$_baseUrl/api/v1/resource';

  // Health check
  String get healthcheck => '$_baseUrl/api/v1/health/protected';

  String get reverseGeocoding => 'https://nominatim.openstreetmap.org/reverse';

  // Auth Routes
  String get thirdPartyLogin => '$_baseUrl/api/v1/user/thirdPartyLogin';
  String get logout => '$_baseUrl/api/v1/user/logout';
  String get refresh => '$_baseUrl/api/v1/user/refresh';

  String get saveKeys => '$_baseUrl/api/v1/e2ee';
  String get getKeys => '$_baseUrl/api/v1/e2ee/keys';
  String get getPublicKey => '$_baseUrl/api/v1/e2ee/key';

  String get me => '$_baseUrl/api/v1/user/protected/me';
  String get addSocial => '$_baseUrl/api/v1/user/protected/socials';
  String get deleteSocial => '$_baseUrl/api/v1/user/protected/socials';

  String get privacyPolicy => '$_baseUrl/privacy_policy';
  String get termsAndConditions => '$_baseUrl/terms_and_conditions';

  String get verifyAccount => '$_baseUrl/api/v1/verification/identity';
  String get vendorApplication => '$_baseUrl/api/v1/applications';

  String get search => '$_baseUrl/api/v1/services/search';
  String get serviceDetails => '$_baseUrl/api/v1/services';
  String get findRoute => '$_baseUrl/api/v1/services/route';

  String get websocket => '$_wsUrl/api/v1/chat/ws';
  String get conversations => '$_baseUrl/api/v1/chat/conversations';
  String get getMessages => '$_baseUrl/api/v1/chat/messages';
  String get sendMessage => '$_baseUrl/api/v1/chat/send';

  String get vendor => '$_baseUrl/api/v1/vendors';
  String get vendorServices => '$_baseUrl/api/v1/vendors/services';

  String get addService => '$_baseUrl/api/v1/services';
  String get updateService => '$_baseUrl/api/v1/services';

  String get addExtra => '$_baseUrl/api/v1/services/addExtra';
  String get editExtra => '$_baseUrl/api/v1/services/editExtra';
  String get deleteExtra => '$_baseUrl/api/v1/services/deleteExtra';

  String get addImage => '$_baseUrl/api/v1/services/addImage';
  String get deleteImage => '$_baseUrl/api/v1/services/deleteImage';

  String get savedServices => '$_baseUrl/api/v1/services/get-saved';
  String get saveService => '$_baseUrl/api/v1/services/save';
  String get unsaveService => '$_baseUrl/api/v1/services/unsave';

  String get createBooking => '$_baseUrl/api/v1/transactions';
  String get cancelBooking => '$_baseUrl/api/v1/transactions/cancel';
  String get acceptRequest => '$_baseUrl/api/v1/transactions/accept';
  String get rejectRequest => '$_baseUrl/api/v1/transactions/reject';
  String get completeTransaction => '$_baseUrl/api/v1/transactions/complete';
  String get toReviews => '$_baseUrl/api/v1/transactions/toReview';
  String get postReview => '$_baseUrl/api/v1/reviews';
  String get getTransaction => '$_baseUrl/api/v1/transactions';
  String get recent => '$_baseUrl/api/v1/transactions/recent';
  String get history => '$_baseUrl/api/v1/transactions/history';
  String get confirmed => '$_baseUrl/api/v1/transactions/confirmed';
  String get myRequests => '$_baseUrl/api/v1/transactions/mine';
  String get clientRequests => '$_baseUrl/api/v1/transactions/mine';

  String get expertiseList => '$_baseUrl/api/v1/tags/expertise';

  String get qrSignature => '$_baseUrl/api/v1/qr/generateSignature';
  String get qrVerifySignature => '$_baseUrl/api/v1/qr/verifySignature';

  String get getNotifications => '$_baseUrl/api/v1/notifications';
  String get readNotification => '$_baseUrl/api/v1/notifications';

  String get reportBug => '$_baseUrl/api/v1/complaints/system';
  String get reportUser => '$_baseUrl/api/v1/complaints/user';
}
