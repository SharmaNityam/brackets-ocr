import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class CameraService {
  static Future<List<CameraDescription>> getAvailableCameras() async {
    return await availableCameras();
  }

  static Future<CameraController> initializeCamera(
      CameraDescription camera) async {
    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller.initialize();
    return controller;
  }

  static Future<String> captureImage(CameraController controller) async {
    final XFile image = await controller.takePicture();

    // Get app directory for saving images
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String imagePath = '${appDir.path}/scan_$timestamp.jpg';

    // Copy captured image to app directory
    await File(image.path).copy(imagePath);

    return imagePath;
  }

  static void disposeController(CameraController? controller) {
    controller?.dispose();
  }
}
