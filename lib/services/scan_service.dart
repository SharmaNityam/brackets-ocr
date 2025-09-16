import 'dart:io';
import '../models/scan_result.dart';
import '../services/ocr_service.dart';
import '../services/database_helper.dart';

class ScanService {
  static const double rectWidth = 0.85;
  static const double rectHeight = 0.30;
  static const double rectX = (1.0 - rectWidth) / 2;
  static const double rectY = (1.0 - rectHeight) / 2;

  static Future<ScanResult> processImage(String originalImagePath) async {
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    // Crop image to rectangle bounds
    final String? croppedPath = await OCRService.cropImage(
        originalImagePath, rectX, rectY, rectWidth, rectHeight);

    if (croppedPath == null) {
      throw Exception('Failed to crop image to rectangle bounds');
    }

    // Extract numbers using OCR
    final List<String> numbers = await OCRService.extractNumbers(croppedPath);

    // Create scan result
    final ScanResult result = ScanResult(
      id: timestamp,
      timestamp: DateTime.now(),
      extractedNumbers: numbers,
      imagePath: croppedPath,
    );

    // Save to database
    await DatabaseHelper().insertScanResult(result);

    // Clean up original image
    if (File(originalImagePath).existsSync()) {
      await File(originalImagePath).delete();
    }

    return result;
  }

  static Future<List<ScanResult>> getAllScanResults() async {
    return await DatabaseHelper().getAllScanResults();
  }

  static Future<void> deleteScanResult(String id) async {
    await DatabaseHelper().deleteScanResult(id);
  }
}
