import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// text r

class TextRecognition {

  //  recognizing text
   static Future <String> captureText (InputImage inputImage) async {
      print("object");
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String text = recognizedText.text;
      // for (TextBlock block in recognizedText.blocks) {
      //     // final Rect rect_ = block.rect;
      //     // final List<Offset> cornerPoints = block.cornerPoints;
      //     final String text = block.text;
      //     final List<String> languages = block.recognizedLanguages;

      //     for (TextLine line in block.lines) {
      //       // Same getters as TextBlock
      //       for (TextElement element in line.elements) {
      //         // Same getters as TextBlock
      //       }
      //     }
      // }
      return "$text";
   }

}