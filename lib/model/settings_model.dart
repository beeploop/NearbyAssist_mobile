import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/tag_model.dart';
import 'package:nearby_assist/model/user_info.dart';
import 'package:nearby_assist/request/dio_request.dart';
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
    if (kDebugMode) {
      print('Loading settings');
    }

    try {
      await getIt.get<StorageService>().loadData();
      await loadBackendAddr();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading settings');
      }
    }
  }

  Future<void> loadBackendAddr() async {
    try {
      _backendUrl =
          await getIt.get<StorageService>().getStringData(_backendUrlKey);
      _serverAddr = 'http://$_backendUrl';
      _websocketAddr = 'ws://$_backendUrl';
    } catch (e) {
      if (kDebugMode) {
        print('Error loading settings from storage. Loading from env instead');
      }

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
      final response = await request.get("/v1/public/users/me");
      final user = UserInfo.fromJson(response.data['user']);
      getIt.get<AuthModel>().saveUser(user);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user information: $e');
      }
      rethrow;
    }
  }

  Future<void> updateSavedTags() async {
    try {
      final request = DioRequest();
      final response = await request.get("/tags", requireAuth: false);
      List data = response.data['tags'];
      final tags = data.map((element) {
        return TagModel.fromJson(element);
      }).toList();

      await getIt.get<StorageService>().saveTags(tags);
      await getIt.get<StorageService>().loadData();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating saved tags: $e');
      }
      rethrow;
    }
  }
}
