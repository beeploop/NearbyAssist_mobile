import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/settings_model.dart';

abstract class Request {
  String serverAddr = getIt.get<SettingsModel>().getServerAddr();

  Future<dynamic> getRequest(String endpoint);

  Future<dynamic> postRequest(String endpoint, dynamic body);
}
