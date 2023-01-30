import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class BarcodeRecognition {

  final List<BarcodeFormat> formats = [BarcodeFormat.all];
  static var barcodeScanner;

  BarcodeRecognition getInstance () {
    barcodeScanner = BarcodeScanner(formats: formats);
    return new BarcodeRecognition();
  }

}