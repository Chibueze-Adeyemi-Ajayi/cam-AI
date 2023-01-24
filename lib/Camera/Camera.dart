import 'package:camera/camera.dart';

class Camera {

  // Available cameras
  static late List <CameraDescription> cameras;

  // available 
  static Future <List <CameraDescription>> _getAvailableCameras () async {
    cameras = await availableCameras();
    return cameras;
  }

  static late CameraController controller;
  // camera controllers 
  static Future <CameraController> getCameraController (int index) async {
    List <CameraDescription> desc = await _getAvailableCameras();
    controller = CameraController(desc[index], ResolutionPreset.max);
    return controller;
  }

  // initializing the camera controller
  static Future <void> initCamera (CameraController camController, Function callback) async {
    try {
     await camController.initialize();
     callback(false, "Camera successfully initialized");
    } catch (exception) { callback(false, exception); }
  }

}