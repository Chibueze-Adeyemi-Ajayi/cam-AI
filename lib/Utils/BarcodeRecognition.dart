import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class BarcodeRecognition {

  static final List<BarcodeFormat> formats = [BarcodeFormat.all];
  static var barcodeScanner;

  static BarcodeRecognition getInstance () {
    barcodeScanner = BarcodeScanner(formats: formats);
    return new BarcodeRecognition();
  }

  Future <void> processCode (InputImage image, Function callback) async {

    try {

      final List<Barcode> barcodes = await barcodeScanner.processImage(image);
        
        for (Barcode barcode in barcodes) {
              final BarcodeType type = barcode.type;
              //final Rect boundingBox = barcode.boundingBox;
              final String? displayValue = barcode.displayValue;
              final String? rawValue = barcode.rawValue;

              // See API reference for complete list of supported types
              switch (type) {
                case BarcodeType.wifi:
                  var barcodeWifi = barcode.value;
                  callback(true, barcodeWifi);
                  break;
                case BarcodeType.url:
                  var barcodeUrl = barcode.value;
                  callback(true, barcodeUrl);
                  break;
                default: callback(false, "Unknown bar code");
              }
        }

    } catch (e) { callback(false, e.toString());}

  }

}