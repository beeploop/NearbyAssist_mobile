import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SettingsModel extends ChangeNotifier {
  String? _serverAddr;
  String? _websocketAddr;

  Future<void> loadSettings() async {
    await dotenv.load(fileName: ".env");

    try {
      final url = dotenv.get('BACKEND_URL');
      _serverAddr = 'http://$url';
      _websocketAddr = 'ws://$url';
    } catch (e) {
      _serverAddr = null;
      _websocketAddr = null;
    }
  }

  void setServer(String addr) {
    _serverAddr = addr;
    notifyListeners();
  }

  void setWebsocket(String addr) {
    _websocketAddr = addr;
    notifyListeners();
  }

  String getServerAddr() => _serverAddr == null ? '' : _serverAddr!;
  String getWebsocketAddr() => _websocketAddr == null ? '' : _websocketAddr!;
}
