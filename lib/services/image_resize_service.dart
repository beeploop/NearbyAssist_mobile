import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:nearby_assist/main.dart';

class ImageResizeService {
  static const _width = 800;
  static const _resizeQuality = 85;

  static Uint8List resize(Uint8List imageBytes) {
    logger.logDebug('called resize');

    try {
      final image = decodeImage(imageBytes);
      if (image == null) throw 'NullImage';

      final resized = copyResize(image, width: _width);
      return encodeJpg(resized, quality: _resizeQuality);
    } catch (error) {
      rethrow;
    } finally {
      logger.logDebug('resize complete');
    }
  }
}
