import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart';
import 'package:nearby_assist/services/image_resize_service.dart';

void main() {
  group('ImageResizeService', () {
    test('should resize image to 800px width while preserving aspect ratio',
        () {
      // Create a fake image: 1600x1200 (landscape)
      final original = Image(width: 1600, height: 1200);
      final originalBytes = Uint8List.fromList(encodeJpg(original));

      final processedImg = ImageResizeService.resize(originalBytes);

      final result = decodeImage(processedImg)!;

      expect(result.width, equals(800));
      expect(result.height, lessThan(1200)); // aspect ratio preserved
    });

    test('should throw when input image is invalid', () {
      final invalidBytes = Uint8List.fromList([0, 1, 2, 3]);

      expect(() => ImageResizeService.resize(invalidBytes),
          throwsA(isA<Object>()));
    });
  });
}
