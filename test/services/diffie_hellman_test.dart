import 'package:flutter_test/flutter_test.dart';
import 'package:nearby_assist/services/diffie_hellman.dart';

void main() {
  group('DiffieHellman', () {
    final dh = DiffieHellman();

    test('keyPairFrom', () {
      final originalKeyPair = dh.generateKeyPair();
      final privatePem = originalKeyPair.privateKey.toPem();
      final publicPem = originalKeyPair.publicKey.toPem();

      final reconstructed = dh.keyPairFrom(privatePem, publicPem);

      expect(reconstructed.privateKey.value, originalKeyPair.privateKey.value);
      expect(reconstructed.publicKey.value, originalKeyPair.publicKey.value);
    });

    test('test computing shared secret', () async {
      final alice = dh.generateKeyPair();
      final bob = dh.generateKeyPair();

      final aliceSecret = await dh.computeSharedSecret(alice, bob.publicKey);
      final bobSecret = await dh.computeSharedSecret(bob, alice.publicKey);

      expect(aliceSecret, equals(bobSecret));
    });
  });
}
