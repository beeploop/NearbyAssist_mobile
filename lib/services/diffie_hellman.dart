import 'package:diffie_hellman/diffie_hellman.dart';
import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/key_model.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/services/secure_storage.dart';

class DiffieHellman {
  /// checks for locally saved keypair. generate keypair if no keypair is found and saves them locally and to the server.
  Future<DhKeyPair> register() async {
    logger.logDebug('called register in diffie_hellman.dart');

    try {
      DhKeyPair? keypair;

      keypair = await _getSavedKeys();
      keypair ??= await _getKeysFromServer();
      keypair ??= _generateKeyPair();

      await _saveKeysToServer(keypair);
      await _saveLocally(keypair);

      return keypair;
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
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
    logger.logDebug('called computSharedSecret in diffie_hellman.dart');

    try {
      final keyPair = await _getSavedKeys();
      if (keyPair == null) {
        throw LocalKeysNotFoundException();
      }

      final engine = DhPkcs3Engine.fromKeyPair(keyPair);
      return engine.computeSecretKey(otherUserPublicKey.value);
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  DhKeyPair _generateKeyPair() {
    DhPkcs3Engine engine = DhPkcs3Engine.fromGroup(DhGroup.g14);
    return engine.generateKeyPair();
  }

  Future<DhKeyPair?> _getSavedKeys() async {
    logger.logDebug('called getSavedKeys in diffie_hellman.dart');

    try {
      final store = SecureStorage();
      final privatePem = await store.getKey(KeyType.privateKey);
      final publicPem = await store.getKey(KeyType.publicKey);
      if (privatePem == null || publicPem == null) {
        return null;
      }

      final privateKey = DhPrivateKey.fromPem(privatePem);
      final publicKey = DhPublicKey.fromPem(publicPem);

      final keypair = DhKeyPair(privateKey: privateKey, publicKey: publicKey);
      return keypair;
    } catch (error) {
      logger.logError(error.toString());
      return null;
    }
  }

  Future<DhKeyPair?> _getKeysFromServer() async {
    logger.logDebug('called getKeysFromServer in diffie_hellman.dart');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.getKeys);
      final keys = response.data;

      final publicKey = DhPublicKey.fromPem(keys["publicKey"]);
      final privateKey = DhPrivateKey.fromPem(keys["privateKey"]);
      return DhKeyPair(publicKey: publicKey, privateKey: privateKey);
    } catch (error) {
      logger.logError(error.toString());
      return null;
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

class LocalKeysNotFoundException implements Exception {}
