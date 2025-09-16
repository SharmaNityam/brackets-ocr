import 'package:flutter/material.dart';

class CameraControls extends StatelessWidget {
  final bool isProcessing;
  final VoidCallback onCapture;

  const CameraControls({
    super.key,
    required this.isProcessing,
    required this.onCapture,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Column(
        children: [
          _buildCaptureButton(),
          const SizedBox(height: 12),
          _buildCaptureHint(),
        ],
      ),
    );
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: isProcessing ? null : onCapture,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: isProcessing ? 70 : 80,
        height: isProcessing ? 70 : 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isProcessing ? Colors.grey[300] : Colors.white,
          border: Border.all(
            color: Colors.white,
            width: isProcessing ? 2 : 4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isProcessing
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.black54,
                ),
              )
            : const Icon(
                Icons.camera_alt_rounded,
                size: 36,
                color: Colors.black87,
              ),
      ),
    );
  }

  Widget _buildCaptureHint() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isProcessing ? 'Processing...' : 'Tap to capture',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
