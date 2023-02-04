// for detecting pose in an image

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseDetection {
  static Future <List<Pose>> getPose(inputImage) async {
    final options = PoseDetectorOptions();
    final poseDetector = PoseDetector(options: options);
    final List <Pose> poses = await poseDetector.processImage(inputImage);
    return poses;
  }
}