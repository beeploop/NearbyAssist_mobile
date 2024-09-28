import 'dart:io';

import 'package:diffie_hellman/diffie_hellman.dart';
import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/request/dio_request.dart';
import 'package:nearby_assist/services/storage_service.dart';

class DiffieHellman {
  /// checks for locally saved keypair. generate keypair if no keypair is found and saves them locally and to the server.
  Future<DhKeyPair> register() async {
    DhKeyPair? keypair;
    try {
      keypair = await _getSavedKeys();
    } catch (err) {
      if (kDebugMode) {
        print("No locally saved keys: $err");
      }
    }

    if (keypair == null) {
      try {
        keypair = await _getKeysFromServer();
      } catch (err) {
        if (kDebugMode) {
          print("Error getting keys from server: $err");
        }
      }
    }

    keypair ??= _generateKeyPair();
    try {
      await _saveKeysToServer(keypair);
    } catch (err) {
      if (kDebugMode) {
        print("Error saving keys to server: $err");
      }
    }

    _saveLocally(keypair);

    return keypair;
  }

  /// retrieves the public key of the specified user
  Future<DhPublicKey> getPublicKey(String userId) async {
    try {
      final request = DioRequest();
      final response = await request.get("/api/v1/e2ee/key/$userId");

      return DhPublicKey.fromPem(response.data["key"]);
    } catch (err) {
      rethrow;
    }
  }

  /// computes a shared secret. throws error if there are no locally saved keypair.
  Future<BigInt> computeSharedSecret(DhPublicKey otherUserPublicKey) async {
    DhKeyPair keyPair;
    try {
      keyPair = await _getSavedKeys();
    } catch (err) {
      if (kDebugMode) {
        print("no saved keys");
      }
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
      final privatePem = await getIt.get<StorageService>().getPrivatePem();
      final publicPem = await getIt.get<StorageService>().getPublicPem();

      final privateKey = DhPrivateKey.fromPem(privatePem);
      final publicKey = DhPublicKey.fromPem(publicPem);

      final keypair = DhKeyPair(privateKey: privateKey, publicKey: publicKey);
      return keypair;
    } catch (err) {
      rethrow;
    }
  }

  Future<DhKeyPair> _getKeysFromServer() async {
    try {
      final request = DioRequest();
      final response = await request.get("/api/v1/e2ee/keys");
      final keys = response.data;

      final publicKey = DhPublicKey.fromPem(keys["publicKey"]);
      final privateKey = DhPrivateKey.fromPem(keys["privateKey"]);
      return DhKeyPair(publicKey: publicKey, privateKey: privateKey);
    } catch (err) {
      rethrow;
    }
  }

  Future<void> _saveKeysToServer(DhKeyPair keypair) async {
    try {
      final publicKeyPem = keypair.publicKey.toPem();
      final privateKeyPem = keypair.privateKey.toPem();

      final request = DioRequest();
      await request.post(
        "/api/v1/e2ee",
        {
          "privatePem": privateKeyPem,
          "publicPem": publicKeyPem,
        },
        expectedStatus: HttpStatus.noContent,
      );
    } catch (err) {
      rethrow;
    }
  }

  Future<void> _saveLocally(DhKeyPair keypair) async {
    final publicKeyPem = keypair.publicKey.toPem();
    final privateKeyPem = keypair.privateKey.toPem();

    await getIt.get<StorageService>().savePrivatePem(privateKeyPem);
    await getIt.get<StorageService>().savePublicPem(publicKeyPem);
  }
}
