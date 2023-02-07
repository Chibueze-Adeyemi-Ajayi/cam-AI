import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as image_lib;

class ImageProcessor {
  
    static InputImage getInputImage (XFile file) {
      return InputImage.fromFilePath(file.path);
    }

    static inputImage convertCameraImage (CameraImage cam_img) {
      image_lib.Image img = image_lib.Image.fromBytes(
          width: cam_img.width, 
          height: cam_img.height, 
          bytes: cam_img.planes[0].bytes,
          format: image_lib.Format.bgra);
    }

}