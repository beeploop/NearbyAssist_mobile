import 'package:flutter/foundation.dart';
import 'package:nearby_assist/services/secure_storage.dart';

class KeyPairProvider extends ChangeNotifier {
  String? _privatePem;
  String? _publicPem;

  static final KeyPairProvider _instance = KeyPairProvider._internal();

  KeyPairProvider._internal();

  factory KeyPairProvider() => _instance;

  String? get privateKey => _privatePem;
  String? get publicKey => _publicPem;

  Future<void> updateKeys({
    required String private,
    required String public,
  }) async {
    _privatePem = private;
    _publicPem = public;

    await SecureStorage().saveKey(KeyType.privateKey, private);
    await SecureStorage().saveKey(KeyType.publicKey, public);

    notifyListeners();
  }

  Future<void> loadFromLocal() async {
    final store = SecureStorage();
    final privatePem = await store.getKey(KeyType.privateKey);
    final publicPem = await store.getKey(KeyType.publicKey);
    if (privatePem == null || publicPem == null) {
      return;
    }

    _privatePem = privatePem;
    _publicPem = publicPem;

    notifyListeners();
  }

  void clearKeys() {
    _privatePem = null;
    _publicPem = null;
    notifyListeners();
  }
}

class MissingKeyException implements Exception {
  final String message;
  MissingKeyException({required this.message});
}
