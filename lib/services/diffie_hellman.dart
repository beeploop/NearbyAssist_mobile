import 'package:diffie_hellman/diffie_hellman.dart';
import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/key_model.dart';
import 'package:nearby_assist/providers/key_pair_provider.dart';
import 'package:nearby_assist/services/api_service.dart';

class DiffieHellman {
  /// checks for server saved keypair. generate keypair if no keypair is found and saves them locally and to the server.
  Future<DhKeyPair> register() async {
    logger.logDebug('called register in diffie_hellman.dart');

    try {
      DhKeyPair? keypair;

      keypair = await _getKeysFromServer();
      keypair ??= generateKeyPair();

      await _saveKeysToServer(keypair);

      final publicKeyPem = keypair.publicKey.toPem();
      final privateKeyPem = keypair.privateKey.toPem();
      await KeyPairProvider()
          .updateKeys(private: privateKeyPem, public: publicKeyPem);

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
  Future<BigInt> computeSharedSecret(
    DhKeyPair currentUserKeyPair,
    DhPublicKey otherUserPubKey,
  ) async {
    logger.logDebug('called computSharedSecret in diffie_hellman.dart');

    try {
      final engine = DhPkcs3Engine.fromKeyPair(currentUserKeyPair);
      return engine.computeSecretKey(otherUserPubKey.value);
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  DhKeyPair generateKeyPair() {
    DhPkcs3Engine engine = DhPkcs3Engine.fromGroup(DhGroup.g14);
    return engine.generateKeyPair();
  }

  DhKeyPair keyPairFrom(String private, String public) {
    final privateKey = DhPrivateKey.fromPem(private);
    final publicKey = DhPublicKey.fromPem(public);

    final keypair = DhKeyPair(privateKey: privateKey, publicKey: publicKey);
    return keypair;
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
}
