import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<PermissionStatus> getCameraPermissionStatus() async {
    return await Permission.camera.status;
  }

  static Future<PermissionStatus> requestCameraPermission() async {
    return await Permission.camera.request();
  }

  static Future<void> openDeviceSettings() async {
    await openAppSettings();
  }

  static bool isPermissionGranted(PermissionStatus status) {
    return status == PermissionStatus.granted;
  }

  static bool isPermissionDenied(PermissionStatus status) {
    return status == PermissionStatus.denied;
  }

  static bool isPermissionPermanentlyDenied(PermissionStatus status) {
    return status == PermissionStatus.permanentlyDenied;
  }
}
