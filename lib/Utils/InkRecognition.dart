import 'package:learning_digital_ink_recognition/learning_digital_ink_recognition.dart';

class InkRecognition {

  // language code
  static String languageCode = "en"; // BCP-47 Code from https://developers.google.com/ml-kit/vision/digital-ink-recognition/base-models?hl=en#text
  static DigitalInkRecognition recognition = DigitalInkRecognition(model: 'en-US');

  // processing ink
  static Future processInk () async {
    
  }

}