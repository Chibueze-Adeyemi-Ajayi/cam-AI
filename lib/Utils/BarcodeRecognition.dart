import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class BarcodeRecognition {

  final List<BarcodeFormat> formats = [BarcodeFormat.all];
  static var barcodeScanner;

  BarcodeRecognition getInstance () {
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
                  break;
                case BarcodeType.url:
                  var barcodeUrl = barcode.value;
                  break;
              }
        }

    } catch (e) { callback(false, e.toString());}

  }

}