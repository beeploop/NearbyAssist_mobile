import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/expertise_model.dart';
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
  final String _expertiseKey = 'expertiseKey';
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
    final userData = jsonEncode(user);
    await _storage.write(key: _userKey, value: userData);
  }

  Future<UserModel> getUser() async {
    try {
      final value = await _storage.read(key: _userKey);
      if (value == null) throw Exception('User not found');

      return UserModel.fromJson(jsonDecode(value));
    } catch (error) {
      logger.log('Error on get user: ${error.toString()}');
      rethrow;
    }
  }

  Future<void> saveKey(KeyType type, String value) async {
    await _storage.write(key: type.key, value: value);
  }

  Future<String?> getKey(KeyType type) async {
    return await _storage.read(key: type.key);
  }

  Future<void> saveTags(List<ExpertiseModel> expertises) async {
    final tagsData = jsonEncode(expertises);
    await _storage.write(key: _expertiseKey, value: tagsData);
  }

  Future<List<ExpertiseModel>> getTags() async {
    try {
      final value = await _storage.read(key: _expertiseKey);
      if (value == null) throw Exception('Expertises not found');

      List<dynamic> expertises = jsonDecode(value);

      return (expertises)
          .map((expertise) => ExpertiseModel.fromJson(expertise))
          .toList();
    } catch (error) {
      logger.log('Error on get tags: ${error.toString()}');
      rethrow;
    }
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
