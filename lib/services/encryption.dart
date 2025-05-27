import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:nearby_assist/main.dart';

class Encryption {
  Key _key;

  Encryption({
    required Key key,
  }) : _key = key;

  Key get key => _key;

  static Uint8List _binIntToUint8List(BigInt number) {
    var hex = number.toRadixString(16);
    if (hex.length % 2 == 1) hex = '0$hex';

    final bytes = List<int>.generate(
      hex.length ~/ 2,
      (i) => int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16),
    );

    return Uint8List.fromList(bytes);
  }

  factory Encryption.fromBigInt(BigInt sharedSecret) {
    try {
      final bytes = _binIntToUint8List(sharedSecret);

      Uint8List keyBytes = Uint8List(32);
      final offset = 32 - bytes.length;

      if (bytes.length > 32) {
        keyBytes = bytes.sublist(0, 32);
      } else {
        for (int i = 0; i < bytes.length; i++) {
          keyBytes[offset + i] = bytes[i];
        }
      }

      final key = Key(keyBytes);

      return Encryption(key: key);
    } catch (error) {
      rethrow;
    }
  }

  String encrypt(String text) {
    try {
      final iv = IV(_generateIv());
      final encrypter = Encrypter(
        AES(_key, mode: AESMode.cbc, padding: 'PKCS7'),
      );

      final encrypted = encrypter.encrypt(text, iv: iv);
      return "${base64.encode(iv.bytes)}:${encrypted.base64}";
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  String decrypt(String encrypted) {
    try {
      final parts = encrypted.split(":");
      if (parts.length != 2) {
        throw const FormatException(
          'Encrypted string is not in expected format',
        );
      }

      final iv = IV.fromBase64(parts[0]);
      Encrypted msg = Encrypted.fromBase64(parts[1]);

      final encrypter = Encrypter(
        AES(_key, mode: AESMode.cbc, padding: 'PKCS7'),
      );
      return encrypter.decrypt(msg, iv: iv);
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Uint8List _generateIv() {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(16, (i) => random.nextInt(256)),
    );
  }
}
