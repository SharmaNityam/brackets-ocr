import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionWidget extends StatelessWidget {
  final PermissionStatus? permissionStatus;
  final VoidCallback onRequestPermission;
  final VoidCallback onOpenSettings;
  final VoidCallback onRefresh;

  const PermissionWidget({
    super.key,
    required this.permissionStatus,
    required this.onRequestPermission,
    required this.onOpenSettings,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black87, Colors.black],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCameraIcon(),
              const SizedBox(height: 40),
              _buildTitle(),
              const SizedBox(height: 16),
              _buildDescription(),
              const SizedBox(height: 40),
              _buildActionButton(),
              _buildStatusMessage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraIcon() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue.withOpacity(0.3), width: 2),
      ),
      child: const Icon(
        Icons.camera_alt_rounded,
        size: 80,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Camera Access Required',
      style: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription() {
    return Text(
      'To scan numbers from images, this app needs access to your camera. Your privacy is important - images are processed locally on your device.',
      style: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 16,
        height: 1.6,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActionButton() {
    if (permissionStatus == PermissionStatus.permanentlyDenied) {
      return _buildPermanentlyDeniedActions();
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onRequestPermission,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt_rounded, size: 24),
            const SizedBox(width: 12),
            Text(
              permissionStatus == PermissionStatus.denied
                  ? 'Try Again'
                  : 'Grant Camera Permission',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusMessage() {
    if (permissionStatus == PermissionStatus.denied) {
      return Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_rounded, color: Colors.orange),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Permission was denied. Please grant camera access to continue.',
                  style: TextStyle(
                    color: Colors.orange.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildPermanentlyDeniedActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.block_rounded,
            color: Colors.red,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            'Camera permission was permanently denied. Please enable it in your device settings to continue.',
            style: TextStyle(
              color: Colors.red.withOpacity(0.9),
              fontSize: 16,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onOpenSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Open Settings',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: onRefresh,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white54),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Refresh',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
