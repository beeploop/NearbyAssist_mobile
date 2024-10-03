import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/tag_model.dart';
import 'package:nearby_assist/model/user_info.dart';
import 'package:nearby_assist/request/dio_request.dart';
import 'package:nearby_assist/services/logger_service.dart';
import 'package:nearby_assist/services/storage_service.dart';

class SettingsModel extends ChangeNotifier {
  final String _backendUrlKey = 'serverAddr';
  String _backendUrl = '';
  String _serverAddr = '';
  String _websocketAddr = '';

  String getServerAddr() => _serverAddr;
  String getWebsocketAddr() => _websocketAddr;
  String getBackendUrl() => _backendUrl;

  Future<void> loadSettings() async {
    try {
      await loadBackendAddr();
      await getIt.get<StorageService>().loadData();
    } catch (e) {
      ConsoleLogger().log('Error loading settings: $e');
      rethrow;
    }
  }

  Future<void> loadBackendAddr() async {
    try {
      _backendUrl =
          await getIt.get<StorageService>().getStringData(_backendUrlKey);
      _serverAddr = 'http://$_backendUrl';
      _websocketAddr = 'ws://$_backendUrl';
    } catch (e) {
      await dotenv.load(fileName: ".env");
      _backendUrl = dotenv.get('BACKEND_URL');
      _serverAddr = 'http://$_backendUrl';
      _websocketAddr = 'ws://$_backendUrl';
    }
  }

  Future<void> updateBackendUrl(String hostname) async {
    if (hostname.startsWith('http://') || hostname.startsWith('https://')) {
      throw Exception('Invalid hostname');
    }

    if (_backendUrl == hostname) {
      return;
    }

    getIt.get<StorageService>().saveStringData(_backendUrlKey, hostname);
    _backendUrl = hostname;
    _serverAddr = 'http://$_backendUrl';
    _websocketAddr = 'ws://$_backendUrl';
    notifyListeners();
  }

  Future<void> updateUserInformation() async {
    try {
      final request = DioRequest();
      final response = await request.get("/api/v1/user/protected/me");
      final user = UserInfo.fromJson(response.data['user']);
      getIt.get<AuthModel>().saveUser(user);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateSavedTags() async {
    try {
      final request = DioRequest();
      final response = await request.get("/api/v1/tags", requireAuth: false);
      List data = response.data['tags'];
      final tags = data.map((element) {
        return TagModel.fromJson(element);
      }).toList();

      await getIt.get<StorageService>().saveTags(tags);
      await getIt.get<StorageService>().loadData();
    } catch (e) {
      rethrow;
    }
  }
}
