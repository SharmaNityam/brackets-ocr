import 'package:flutter/material.dart';

class CameraOverlay extends StatefulWidget {
  const CameraOverlay({super.key});

  @override
  State<CameraOverlay> createState() => _CameraOverlayState();
}

class _CameraOverlayState extends State<CameraOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        final double screenHeight = constraints.maxHeight;

        // Rectangle dimensions (85% width, 30% height for more rectangular shape)
        final double rectWidth = screenWidth * 0.85;
        final double rectHeight = screenHeight * 0.30;
        final double rectLeft = (screenWidth - rectWidth) / 2;
        final double rectTop = (screenHeight - rectHeight) / 2;

        return AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return CustomPaint(
              size: Size(screenWidth, screenHeight),
              painter: OverlayPainter(
                rectLeft: rectLeft,
                rectTop: rectTop,
                rectWidth: rectWidth,
                rectHeight: rectHeight,
                pulseValue: _pulseAnimation.value,
              ),
            );
          },
        );
      },
    );
  }
}

class OverlayPainter extends CustomPainter {
  final double rectLeft;
  final double rectTop;
  final double rectWidth;
  final double rectHeight;
  final double pulseValue;

  OverlayPainter({
    required this.rectLeft,
    required this.rectTop,
    required this.rectWidth,
    required this.rectHeight,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.65)
      ..style = PaintingStyle.fill;

    // Create the overlay path with a hole for the rectangle
    final Path overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(rectLeft, rectTop, rectWidth, rectHeight),
        const Radius.circular(12),
      ))
      ..fillType = PathFillType.evenOdd;

    // Draw the overlay
    canvas.drawPath(overlayPath, overlayPaint);

    // Draw animated border with gradient effect
    final Paint borderPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.blue.withOpacity(0.8 * pulseValue),
          Colors.cyan.withOpacity(0.6 * pulseValue),
          Colors.blue.withOpacity(0.8 * pulseValue),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(rectLeft, rectTop, rectWidth, rectHeight))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final RRect borderRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(rectLeft, rectTop, rectWidth, rectHeight),
      const Radius.circular(12),
    );
    canvas.drawRRect(borderRect, borderPaint);

    // Draw enhanced corner indicators with glow effect
    final Paint cornerPaint = Paint()
      ..color = Colors.white.withOpacity(0.9 * pulseValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final Paint glowPaint = Paint()
      ..color = Colors.blue.withOpacity(0.3 * pulseValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    const double cornerLength = 24.0;

    // Draw glow effect first
    _drawCorners(canvas, glowPaint, cornerLength);
    // Draw main corners
    _drawCorners(canvas, cornerPaint, cornerLength);

    // Draw center crosshair
    final Paint crosshairPaint = Paint()
      ..color = Colors.white.withOpacity(0.4 * pulseValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final double centerX = rectLeft + rectWidth / 2;
    final double centerY = rectTop + rectHeight / 2;
    const double crosshairSize = 12.0;

    // Horizontal line
    canvas.drawLine(
      Offset(centerX - crosshairSize, centerY),
      Offset(centerX + crosshairSize, centerY),
      crosshairPaint,
    );
    // Vertical line
    canvas.drawLine(
      Offset(centerX, centerY - crosshairSize),
      Offset(centerX, centerY + crosshairSize),
      crosshairPaint,
    );

    // Draw scan line animation
    final Paint scanLinePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          Colors.blue.withOpacity(0.3 * pulseValue),
          Colors.cyan.withOpacity(0.5 * pulseValue),
          Colors.blue.withOpacity(0.3 * pulseValue),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(rectLeft, rectTop, rectWidth, 2))
      ..style = PaintingStyle.fill;

    final double scanY = rectTop + (rectHeight * pulseValue);
    canvas.drawRect(
      Rect.fromLTWH(rectLeft, scanY, rectWidth, 2),
      scanLinePaint,
    );
  }

  void _drawCorners(Canvas canvas, Paint paint, double cornerLength) {
    // Top-left corner
    canvas.drawLine(
      Offset(rectLeft, rectTop + cornerLength),
      Offset(rectLeft, rectTop),
      paint,
    );
    canvas.drawLine(
      Offset(rectLeft, rectTop),
      Offset(rectLeft + cornerLength, rectTop),
      paint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(rectLeft + rectWidth - cornerLength, rectTop),
      Offset(rectLeft + rectWidth, rectTop),
      paint,
    );
    canvas.drawLine(
      Offset(rectLeft + rectWidth, rectTop),
      Offset(rectLeft + rectWidth, rectTop + cornerLength),
      paint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(rectLeft, rectTop + rectHeight - cornerLength),
      Offset(rectLeft, rectTop + rectHeight),
      paint,
    );
    canvas.drawLine(
      Offset(rectLeft, rectTop + rectHeight),
      Offset(rectLeft + cornerLength, rectTop + rectHeight),
      paint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(rectLeft + rectWidth - cornerLength, rectTop + rectHeight),
      Offset(rectLeft + rectWidth, rectTop + rectHeight),
      paint,
    );
    canvas.drawLine(
      Offset(rectLeft + rectWidth, rectTop + rectHeight - cornerLength),
      Offset(rectLeft + rectWidth, rectTop + rectHeight),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
