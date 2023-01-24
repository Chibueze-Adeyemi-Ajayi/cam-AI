import 'package:camera/camera.dart';

class Camera {

  // Available cameras
  static late List <CameraDescription> cameras;

  // available 
  static Future <List <CameraDescription>> getAvailableCameras () async {
    cameras = await availableCameras();
    return cameras;
  }

  static late CameraController controller;
  // camera controllers 
  static Future <CameraController> getCameraController () async {
    List <CameraDescription> desc = await getAvailableCameras();
    controller = CameraController(desc[0], ResolutionPreset.max);
    return controller;
  }

}