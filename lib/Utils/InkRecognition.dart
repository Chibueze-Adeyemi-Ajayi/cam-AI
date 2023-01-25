import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';

class InkRecognition {
  // language code
static String languageCode = "en"; // BCP-47 Code from https://developers.google.com/ml-kit/vision/digital-ink-recognition/base-models?hl=en#text
final digitalInkRecognizer = DigitalInkRecognizer(languageCode: languageCode);
}