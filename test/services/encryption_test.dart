import 'package:flutter_test/flutter_test.dart';
import 'package:nearby_assist/services/encryption.dart';

void main() {
  group('Encryption', () {
    late Encryption encryption;
    late BigInt sharedSecret;

    setUp(() {
      sharedSecret = BigInt.parse('123456789012345678901234567890');
      encryption = Encryption.fromBigInt(sharedSecret);
    });

    test('should encrypt and decrypt correctly', () {
      const text = 'hello world';
      final encrypted = encryption.encrypt(text);
      final decrypted = encryption.decrypt(encrypted);

      expect(decrypted, equals(text));
    });

    test('key should be 32 bytes', () {
      final key = encryption.key;
      expect(key.length, equals(32));
    });

    test('should throw on corrupted text', () {
      const text = 'sensitive info';
      final encrypted = encryption.encrypt(text);

      final parts = encrypted.split(":");
      final corrupted = '${parts[0]}:garbagetext';

      expect(() => encryption.decrypt(corrupted), throwsA(isA<Exception>()));
    });

    test('should throw if using wrong key', () {
      try {
        final encrypted = encryption.encrypt('Secret message');

        // Generate a different key
        final wrongSecret = BigInt.parse('999999999999999999999');
        final wrongEncryption = Encryption.fromBigInt(wrongSecret);

        wrongEncryption.decrypt(encrypted);

        fail("Expected to throw exception but did not");
      } catch (error) {
        expect(error, isA<ArgumentError>());
      }
    });

    test('should produce different ciphertexts for same input', () {
      const text = 'Same message';
      final encrypted1 = encryption.encrypt(text);
      final encrypted2 = encryption.encrypt(text);

      expect(encrypted1, isNot(equals(encrypted2))); // due to random IV
    });
  });
}
