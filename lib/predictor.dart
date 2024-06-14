import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';

class Predictor {
  static Interpreter? interpreter;

  Predictor() {
    loadModel();
  }

  void loadModel() async {
    if (interpreter != null) return;

    try {
      interpreter = await Interpreter.fromAsset('assets/model/model.tflite');
    } catch (e) {
      debugPrint("ERROR loading assets: $e");
    }
  }

  Future<List<double>> predict(String path) async {
    final bytes = await File(path).readAsBytes();
    final img.Image? capturedImage = img.decodeImage(bytes);

    if (capturedImage != null) {
      final scaledImage =
          img.copyResize(capturedImage, width: 256, height: 256);

      final imageMatrix = List.generate(
        scaledImage.height,
        (y) => List.generate(
          scaledImage.width,
          (x) {
            final pixel = scaledImage.getPixel(x, y);
            return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
          },
        ),
      );

      final input = [imageMatrix];

      final out = [List<double>.filled(3, 0)];
      interpreter!.run(input, out);
      return out.first;
    }
    return List.empty();
  }

  void dispose() {
    interpreter!.close();
  }
}
