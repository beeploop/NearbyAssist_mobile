import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum TokenType {
  accessToken(key: 'accessToken'),
  refreshToken(key: 'refreshToken');

  const TokenType({required this.key});
  final String key;
}

class SecureStorage {
  late FlutterSecureStorage _storage;

  SecureStorage() {
    _storage = const FlutterSecureStorage();
  }

  Future<void> store(TokenType type, String value) async {
    await _storage.write(key: type.key, value: value);
  }

  Future<String?> get(TokenType type) async {
    return await _storage.read(key: type.key);
  }

  Future<void> clear(TokenType type) async {
    await _storage.delete(key: type.key);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
