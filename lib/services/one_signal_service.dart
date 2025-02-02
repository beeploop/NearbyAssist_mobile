import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  void initialize() {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.consentRequired(true);
    OneSignal.consentGiven(true);
    OneSignal.initialize(dotenv.get('ONE_SIGNAL_APP_ID'));
    OneSignal.Notifications.requestPermission(true);

    OneSignal.User.addObserver((state) {
      final json = state.jsonRepresentation();
      logger.log('------- user changed: $json');
    });
  }

  void updateUser(UserModel? user) {
    if (user == null) {
      OneSignal.logout();
      return;
    }

    OneSignal.login(user.id);
  }
}
