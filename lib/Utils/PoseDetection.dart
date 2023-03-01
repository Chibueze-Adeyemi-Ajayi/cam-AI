// for detecting pose in an image

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

// Pose detection class 

class PoseDetection {
  // connecting to google's algorithm
  static final options = PoseDetectorOptions();
  static final poseDetector = PoseDetector(options: options);
  static Future <List<Pose>> getPose(inputImage) async {
    final List <Pose> poses = await poseDetector.processImage(inputImage);
    return poses;
  }
  // closing connection to pose
  static close () {
    poseDetector.close();
  }
} 