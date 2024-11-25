import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageEditor {
  Uint8List? _image;

  Uint8List? get image => _image;

  static Future<String> getFullFilePath(String filename) async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final filePath = path.join(documentDirectory.path, filename);
    if (await File(filePath).exists()) {
      return filePath;
    } else {
      throw Exception("File not found");
    }
  }

  Future<String?> pickImage(bool fromCamera) async {
    final image = fromCamera ? await ImagePicker().pickImage(source: ImageSource.camera) : await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return "No image selected";
    final bytes = await image.readAsBytes();
    _image = bytes;
    try {
      cropImage();
      resizeImage(500);
    } catch (e) {
      return "An error occured while editing the image: ${e.toString()}";
    }
    return null;
  }

  Future<String?> saveImage(String fileName, Uint8List image) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final filename = fileName;
    final savedFile = File(path.join(documentsDirectory.path, filename));
    await savedFile.writeAsBytes(image, mode: FileMode.write);
    return path.basename(savedFile.path);
  }

  Future<void> loadImageFromStorage(String filename) async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final filePath = File(path.join(documentDirectory.path, filename));
    if (await filePath.exists()) {
      _image = await filePath.readAsBytes();
    }
  }

  Future<void> deleteImageFromStorage(String filename) async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final filePath = File(path.join(documentDirectory.path, filename));
    if (await filePath.exists()) {
      await filePath.delete();
    }
  }

  /// Crop the image to a square
  cropImage() {
    try {
      var decodedImage = readBytes();
      var width = decodedImage.width;
      var height = decodedImage.height;
      if (width < height) {
        // Portrait
        var offset = ((height - width) / 2).floor();
        var croppedImage = copyCrop(decodedImage,
            x: 0, y: offset, width: width, height: width);
        _image = encodePng(croppedImage);
      } else {
        // Landscape
        var offset = ((width - height) / 2).floor();
        var croppedImage = copyCrop(decodedImage,
            x: offset, y: 0, width: height, height: height);
        _image = encodePng(croppedImage);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Resize the image to a specific width/height
  resizeImage(int width) {
    try {
      var decodedImage = readBytes();
      var resizedImage = copyResize(decodedImage, width: width);
      _image = encodePng(resizedImage);
    } catch (e) {
      rethrow;
    }
  }

  Image readBytes() {
    if (_image == null) {
      throw Exception("Image is not loaded");
    }
    final decodedImage = decodeImage(_image!);
    if (decodedImage == null) {
      throw Exception('Failed to decode image');
    }
    return decodedImage;
  }
}