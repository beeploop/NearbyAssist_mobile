import 'dart:typed_data';

class FillableImageContainerController {
  Uint8List? imageBytes;

  bool get hasImage => imageBytes != null;

  Uint8List? get image => imageBytes;

  void setImage(Uint8List imageBytes) {
    this.imageBytes = imageBytes;
  }
}
