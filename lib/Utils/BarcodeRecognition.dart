import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import "dart:ui";

class BarcodeRecognition {

  Future processCode (InputImage image) async {

    try {

      String? response = "Empty barcode"; // default barcode response 
      final List<BarcodeFormat> formats = [BarcodeFormat.all];
      var barcodeScanner; // barcode scanner 

      barcodeScanner = BarcodeScanner(formats: formats);
      final List<Barcode> barcodes = await barcodeScanner.processImage(image);
      //response = barcodes.toString();
        for (Barcode barcode in barcodes) { // foreach loop 
              final BarcodeType type = barcode.type; // barcode type 
              final Rect? boundingBox = barcode.boundingBox; // barcode bounding rect 
              final String? displayValue = barcode.displayValue; // displayed value 
              final String? rawValue = barcode.rawValue; // barcode raw value 
              response = rawValue;
              // See API reference for complete list of supported types
              switch (type) {
                case BarcodeType.wifi:
                  var barcodeWifi = barcode.rawValue;
                  //response = barcodeWifi.toString();
                break;
                case BarcodeType.url:
                  var barcodeUrl = barcode.value;
                  //response = barcodeUrl;
                break;
                default: response = "Unknown bar code";
              }
        }

        return response;

    } catch (e) {  }

  }

}