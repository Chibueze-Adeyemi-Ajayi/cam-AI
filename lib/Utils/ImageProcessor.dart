import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// the image pro
class ImageProcessor {
  
    static InputImage getInputImage (XFile file) {
      return InputImage.fromFilePath(file.path);
    }

}