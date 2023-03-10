import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as image_lib;

class ImageProcessor {
  
    static InputImage getInputImage (var file) {
      return InputImage.fromFilePath(file.path);
    }

    static InputImage getInputImageFromLiveStream (CameraImage cameraImage, camera) {
      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in cameraImage.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize = Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());

      InputImageRotation imageRotation = InputImageRotation.rotation0deg;
      switch (camera.sensorOrientation) {
        case 0:
          imageRotation = InputImageRotation.rotation0deg;
          break;
        case 90:
          imageRotation = InputImageRotation.rotation90deg;
          break;
        case 180:
          imageRotation = InputImageRotation.rotation180deg;
          break;
        case 270:
          imageRotation = InputImageRotation.rotation270deg;
          break;
      }

      final inputImageData = InputImageData(
        size: imageSize,
        planeData: null,
        imageRotation: imageRotation,
        inputImageFormat: InputImageFormat.bgra8888
      );

      final inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
      return inputImage;
    }

}