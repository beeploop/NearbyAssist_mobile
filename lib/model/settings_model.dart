import 'package:flutter/material.dart';

class SettingsModel extends ChangeNotifier {
  String _serverAddr = 'http://192.168.186.87:8080';
  String _websocketAddr = 'ws://192.168.186.87:8080';

  void setServer(String addr) {
    _serverAddr = addr;
    notifyListeners();
  }

  void setWebsocket(String addr) {
    _websocketAddr = addr;
    notifyListeners();
  }

  String getServerAddr() => _serverAddr;
  String getWebsocketAddr() => _websocketAddr;
}
