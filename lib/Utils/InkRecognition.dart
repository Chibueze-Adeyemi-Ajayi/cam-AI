import 'package:learning_digital_ink_recognition/learning_digital_ink_recognition.dart';

class InkRecognition {

  // language code
  static String model = "en-US"; // BCP-47 Code from https://developers.google.com/ml-kit/vision/digital-ink-recognition/base-models?hl=en#text
  static DigitalInkRecognition recognition = DigitalInkRecognition(model: model);

  // processing digital ink in firebase ml package
  static Future processInk () async {
    // downloading model 
    // model is a string value, e.g. 'en-US'
    bool isDownloaded = await DigitalInkModelManager.isDownloaded(model);
    // download the model first if it's not downloaded yet
    if (!isDownloaded) {
      await DigitalInkModelManager.download(model);
    }

  }

}