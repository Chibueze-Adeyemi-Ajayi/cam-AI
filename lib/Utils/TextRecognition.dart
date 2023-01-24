import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:ui';

class TextRecognition {

  //  recognizing text
   static Future <String> captureText (InputImage inputImage) async {
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String text = recognizedText.text;
      return text;
   }

}