import 'dart:convert';

import 'package:flutter/services.dart';

class ImageString {
  String toExportFormat(Uint8List imageData) {
    return base64.encode(imageData);
  }

  Uint8List fromExportFormat(String base64String) {
    return base64.decode(base64String);
  }
}