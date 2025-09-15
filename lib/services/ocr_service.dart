import 'dart:io';
import 'dart:typed_data';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;

class OCRService {
  static final TextRecognizer _textRecognizer = TextRecognizer();

  static Future<List<String>> extractNumbers(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      List<String> numbers = [];

      // Sort text blocks by position (top to bottom, left to right)
      List<TextBlock> sortedBlocks = recognizedText.blocks.toList();
      sortedBlocks.sort((a, b) {
        // First sort by Y position (top to bottom)
        int yCompare = a.boundingBox.top.compareTo(b.boundingBox.top);
        if (yCompare != 0) return yCompare;

        // Then sort by X position (left to right)
        return a.boundingBox.left.compareTo(b.boundingBox.left);
      });

      for (TextBlock block in sortedBlocks) {
        for (TextLine line in block.lines) {
          String text = line.text.trim();

          // Extract numbers (including decimals) using regex
          RegExp numberRegex = RegExp(r'\d+\.?\d*');
          Iterable<RegExpMatch> matches = numberRegex.allMatches(text);

          for (RegExpMatch match in matches) {
            String number = match.group(0)!;
            if (number.isNotEmpty) {
              numbers.add(number);
            }
          }
        }
      }

      return numbers;
    } catch (e) {
      // Handle OCR error silently in production
      return [];
    }
  }

  static Future<String?> cropImage(String originalPath, double cropX,
      double cropY, double cropWidth, double cropHeight) async {
    try {
      final File originalFile = File(originalPath);
      final Uint8List imageBytes = await originalFile.readAsBytes();

      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) return null;

      // Convert relative coordinates to pixel coordinates
      int x = (cropX * image.width).round();
      int y = (cropY * image.height).round();
      int width = (cropWidth * image.width).round();
      int height = (cropHeight * image.height).round();

      // Ensure crop bounds are within image bounds
      x = x.clamp(0, image.width - 1);
      y = y.clamp(0, image.height - 1);
      width = width.clamp(1, image.width - x);
      height = height.clamp(1, image.height - y);

      img.Image croppedImage =
          img.copyCrop(image, x: x, y: y, width: width, height: height);

      // Save cropped image
      String croppedPath = originalPath.replaceAll('.jpg', '_cropped.jpg');
      final File croppedFile = File(croppedPath);
      await croppedFile.writeAsBytes(img.encodeJpg(croppedImage));

      return croppedPath;
    } catch (e) {
      // Handle crop error silently in production
      return null;
    }
  }

  static void dispose() {
    _textRecognizer.close();
  }
}
