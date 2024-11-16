import 'package:diffie_hellman/diffie_hellman.dart';
import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/key_model.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/services/secure_storage.dart';

class DiffieHellman {
  /// checks for locally saved keypair. generate keypair if no keypair is found and saves them locally and to the server.
  Future<DhKeyPair> register() async {
    DhKeyPair? keypair;
    try {
      keypair = await _getSavedKeys();
    } catch (error) {
      logger.log('No locally saved keys: $error');
    }

    if (keypair == null) {
      try {
        keypair = await _getKeysFromServer();
      } catch (error) {
        logger.log('No keys found on server: $error');
      }
    }

    keypair ??= _generateKeyPair();
    try {
      await _saveKeysToServer(keypair);
    } catch (error) {
      logger.log('Error saving keys to server: $error');
    }

    _saveLocally(keypair);

    return keypair;
  }

  /// retrieves the public key of the specified user
  Future<DhPublicKey> getPublicKey(String userId) async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get('${endpoint.getPublicKey}/$userId');

      return DhPublicKey.fromPem(response.data["key"]);
    } catch (error) {
      rethrow;
    }
  }

  /// computes a shared secret. throws error if there are no locally saved keypair.
  Future<BigInt> computeSharedSecret(DhPublicKey otherUserPublicKey) async {
    DhKeyPair keyPair;
    try {
      keyPair = await _getSavedKeys();
    } catch (error) {
      logger.log('No saved keys: $error');
      rethrow;
    }

    final engine = DhPkcs3Engine.fromKeyPair(keyPair);
    return engine.computeSecretKey(otherUserPublicKey.value);
  }

  DhKeyPair _generateKeyPair() {
    DhPkcs3Engine engine = DhPkcs3Engine.fromGroup(DhGroup.g14);
    return engine.generateKeyPair();
  }

  Future<DhKeyPair> _getSavedKeys() async {
    try {
      final store = SecureStorage();
      final privatePem = await store.getKey(KeyType.privateKey);
      final publicPem = await store.getKey(KeyType.publicKey);
      if (privatePem == null || publicPem == null) {
        throw Exception('NoSavedKeys');
      }

      final privateKey = DhPrivateKey.fromPem(privatePem);
      final publicKey = DhPublicKey.fromPem(publicPem);

      final keypair = DhKeyPair(privateKey: privateKey, publicKey: publicKey);
      return keypair;
    } catch (error) {
      rethrow;
    }
  }

  Future<DhKeyPair> _getKeysFromServer() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.getKeys);
      final keys = response.data;

      final publicKey = DhPublicKey.fromPem(keys["publicKey"]);
      final privateKey = DhPrivateKey.fromPem(keys["privateKey"]);
      return DhKeyPair(publicKey: publicKey, privateKey: privateKey);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _saveKeysToServer(DhKeyPair keypair) async {
    try {
      final publicKeyPem = keypair.publicKey.toPem();
      final privateKeyPem = keypair.privateKey.toPem();

      final api = ApiService.authenticated();
      await api.dio.post(
        endpoint.saveKeys,
        data: KeyModel(public: publicKeyPem, private: privateKeyPem).toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _saveLocally(DhKeyPair keypair) async {
    final publicKeyPem = keypair.publicKey.toPem();
    final privateKeyPem = keypair.privateKey.toPem();

    final store = SecureStorage();
    await store.saveKey(KeyType.publicKey, publicKeyPem);
    await store.saveKey(KeyType.privateKey, privateKeyPem);
  }
}
