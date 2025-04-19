import 'package:flutter/foundation.dart';

class FillableImageContainerController extends ChangeNotifier {
  Uint8List? imageBytes;

  bool get hasImage => imageBytes != null;

  Uint8List? get image => imageBytes;

  void setImage(Uint8List imageBytes) {
    this.imageBytes = imageBytes;
    notifyListeners();
  }

  void clearImage() {
    imageBytes = null;
    notifyListeners();
  }
}
