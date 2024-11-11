import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

class Encryption {
  Key _key;

  Encryption({
    required Key key,
  }) : _key = key;

  factory Encryption.fromBigInt(BigInt value) {
    var bytes = value.toUnsigned(256).toRadixString(16).padLeft(64, '0');
    Uint8List b = Uint8List.fromList(List<int>.generate(bytes.length ~/ 2,
        (i) => int.parse(bytes.substring(i * 2, i * 2 + 2), radix: 16)));

    final base64Key = base64.encode(b);
    final key = Key.fromBase64(base64Key);

    return Encryption(key: key);
  }

  String encrypt(String text) {
    final iv = IV(_generateIv());
    final encrypter = Encrypter(AES(_key));

    final encrypted = encrypter.encrypt(text, iv: iv);
    return "${base64.encode(iv.bytes)}:${encrypted.base64}";
  }

  String decrypt(String encrypted) {
    final parts = encrypted.split(":");
    final iv = IV.fromBase64(parts[0]);
    Encrypted msg = Encrypted.fromBase64(parts[1]);

    final encrypter = Encrypter(AES(_key));
    return encrypter.decrypt(msg, iv: iv);
  }

  Uint8List _generateIv() {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(16, (i) => random.nextInt(256)),
    );
  }
}
