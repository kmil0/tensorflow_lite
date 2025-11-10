import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class TFService {
  Interpreter? _interpreter;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/mobilenet_v1_1.0_224.tflite',
      );
      print("Model loaded successfully");
      if (_interpreter != null) {
        var inputShape = _interpreter!.getInputTensor(0).shape;
        var outputShape = _interpreter!.getOutputTensor(0).shape;
        print("Input shape: $inputShape");
        print("Output shape: $outputShape");
      }
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future<List<double>> runModel(File? imageFile) async {
    if (_interpreter != null) {
      print("Model loaded");
      return [];
    }

    var input = List.generate(
      1,
      (i) => List.generate(
        224,
        (y) => List.generate(224, (x) => List.filled(3, 0.0)),
      ),
    );

    img.Image imageInput = img.decodeImage(imageFile!.readAsBytesSync())!;
    img.Image resizedImage = img.copyResize(
      imageInput,
      width: 224,
      height: 224,
    );

    for (var i = 0; i < resizedImage.height; i++) {
      for (var j = 0; j < resizedImage.width; j++) {
        var pixel = resizedImage.getPixel(j, i);
        var r = pixel.r;
        var g = pixel.g;
        var b = pixel.b;

        input[0][i][j][0] = r / 255.0;
        input[0][i][j][1] = g / 255.0;
        input[0][i][j][2] = b / 255.0;
      }
    }

    var output = List.filled(1 * 1001, 0.0).reshape([1, 1001]);

    try {
      _interpreter!.run(input, output);
      print("Model run successfully $output");
      return output[0];
    } catch (e) {
      print("Error running model: $e");
      return [];
    }

    }
    void close() {
      _interpreter?.close();
  }
}
