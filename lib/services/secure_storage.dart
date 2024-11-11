import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nearby_assist/models/user_model.dart';

enum TokenType {
  accessToken(key: 'accessToken'),
  refreshToken(key: 'refreshToken');

  const TokenType({required this.key});
  final String key;
}

enum KeyType {
  publicKey(key: 'publicKey'),
  privateKey(key: 'privateKey');

  const KeyType({required this.key});
  final String key;
}

class SecureStorage {
  final String _userKey = 'userKey';
  late FlutterSecureStorage _storage;

  SecureStorage() {
    _storage = const FlutterSecureStorage();
  }

  Future<void> saveToken(TokenType type, String value) async {
    await _storage.write(key: type.key, value: value);
  }

  Future<String?> getToken(TokenType type) async {
    return await _storage.read(key: type.key);
  }

  Future<void> deleteToken(TokenType type) async {
    await _storage.delete(key: type.key);
  }

  Future<void> saveUser(UserModel user) async {
    final userData = jsonEncode(user.toJsonAll());
    await _storage.write(key: _userKey, value: userData);
  }

  Future<UserModel?> getUser() async {
    final value = await _storage.read(key: _userKey);
    if (value == null) return null;

    return UserModel.fromJson(jsonDecode(value));
  }

  Future<void> saveKey(KeyType type, String value) async {
    await _storage.write(key: type.key, value: value);
  }

  Future<String?> getKey(KeyType type) async {
    return await _storage.read(key: type.key);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
