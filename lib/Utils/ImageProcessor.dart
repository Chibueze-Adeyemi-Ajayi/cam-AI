import 'package:camera/camera.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

class ImageProcessor {

    static InputImage getInputImage (XFile file) {
      return InputImage.fromFilePath(file.path);
    }

}