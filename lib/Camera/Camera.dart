import 'package:camera/camera.dart';

class Camera {

  // Available cameras
  static late List <CameraDescription> cameras;

  // available 
  static Future <List <CameraDescription>> getAvailableCameras () async {
    cameras = await availableCameras();
    return cameras;
  }

}