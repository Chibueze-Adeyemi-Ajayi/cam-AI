// for detecting pose in an image

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

// Pose detection class 
// Google firebase ML kit algorithm 
class PoseDetection {
  // connecting to google's algorithm
  static final options = PoseDetectorOptions();
  static final poseDetector = PoseDetector(options: options);
  static Future <List<Pose>> getPose(inputImage) async {
    // li
    final List <Pose> poses = await poseDetector.processImage(inputImage);
    return poses;
  }
  // closing connection to pose google's firebase ML detection algorithm
  static close () {
    poseDetector.close();
  }
} 