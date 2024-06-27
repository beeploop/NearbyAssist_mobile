import 'dart:io';

import 'package:file_picker/file_picker.dart';

class CustomFilePicker {
  Future<List<File>> pickFiles() async {
    FilePickerResult? files = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (files == null) {
      return [];
    }

    return files.paths.map((file) => File(file!)).toList();
  }

  Future<File?> pickFile() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles();

    if (file == null) {
      return null;
    }

    return File(file.paths[0]!);
  }
}
