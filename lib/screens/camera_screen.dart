import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/permission_service.dart';
import '../services/camera_service.dart';
import '../services/scan_service.dart';
import '../widgets/permission_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/camera_overlay.dart';
import '../widgets/camera_controls.dart';
import '../widgets/camera_instructions.dart';
import 'history_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isProcessing = false;
  String? _errorMessage;
  PermissionStatus? _permissionStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestCameraPermissionOnLaunch();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    CameraService.disposeController(_controller);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      if (_controller != null && _controller!.value.isInitialized) {
        _controller!.dispose();
      }
    } else if (state == AppLifecycleState.resumed) {
      _checkPermissionAndInitialize();
    }
  }

  Future<void> _requestCameraPermissionOnLaunch() async {
    final status = await PermissionService.getCameraPermissionStatus();
    if (PermissionService.isPermissionGranted(status)) {
      _initializeCamera();
    } else {
      _requestCameraPermission();
    }
  }

  Future<void> _checkPermissionAndInitialize() async {
    _permissionStatus = await PermissionService.getCameraPermissionStatus();
    if (PermissionService.isPermissionGranted(_permissionStatus!)) {
      _initializeCamera();
    } else {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await PermissionService.requestCameraPermission();
    setState(() {
      _permissionStatus = status;
    });

    if (PermissionService.isPermissionGranted(status)) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      setState(() {
        _errorMessage = null;
        _isInitialized = false;
      });

      _cameras = await CameraService.getAvailableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() {
          _errorMessage = 'No cameras found on this device';
        });
        return;
      }

      _controller = await CameraService.initializeCamera(_cameras![0]);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize camera: ${e.toString()}';
      });
    }
  }

  Future<void> _captureAndProcess() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isProcessing) {
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() {
      _isProcessing = true;
    });

    try {
      final String originalPath =
          await CameraService.captureImage(_controller!);
      final result = await ScanService.processImage(originalPath);

      if (mounted) {
        _showResultSnackBar(result.extractedNumbers);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(e.toString());
      }
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showResultSnackBar(List<String> numbers) {
    final bool hasNumbers = numbers.isNotEmpty;
    final String message = hasNumbers
        ? 'Found ${numbers.length} number${numbers.length == 1 ? '' : 's'}: ${numbers.take(2).join(', ')}${numbers.length > 2 ? '...' : ''}'
        : 'Image saved - No numbers found';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              hasNumbers ? Icons.check_circle : Icons.info,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: hasNumbers ? Colors.green : Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryScreen()),
            );
          },
        ),
      ),
    );
  }

  void _showErrorSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text('Error processing image: $error')),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'OCR Scanner',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
            tooltip: 'View scan history',
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_permissionStatus == null) {
      return const LoadingWidget(message: 'Initializing camera...');
    }

    if (!PermissionService.isPermissionGranted(_permissionStatus!)) {
      return PermissionWidget(
        permissionStatus: _permissionStatus,
        onRequestPermission: _requestCameraPermission,
        onOpenSettings: () => PermissionService.openDeviceSettings(),
        onRefresh: _checkPermissionAndInitialize,
      );
    }

    if (_errorMessage != null) {
      return ErrorDisplayWidget(
        errorMessage: _errorMessage!,
        onRetry: _checkPermissionAndInitialize,
      );
    }

    if (!_isInitialized) {
      return const LoadingWidget(message: 'Initializing camera...');
    }

    return Stack(
      children: [
        Positioned.fill(
          child: CameraPreview(_controller!),
        ),
        const CameraOverlay(),
        const CameraInstructions(),
        CameraControls(
          isProcessing: _isProcessing,
          onCapture: _captureAndProcess,
        ),
      ],
    );
  }
}
