import 'package:flutter/material.dart';
import '../models/scan_result.dart';
import '../services/scan_service.dart';
import '../widgets/scan_result_card.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<ScanResult> _scanResults = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScanResults();
  }

  Future<void> _loadScanResults() async {
    try {
      final results = await ScanService.getAllScanResults();
      setState(() {
        _scanResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        _showErrorSnackBar('Error loading scan results: $e');
      }
    }
  }

  Future<void> _deleteScanResult(String id) async {
    try {
      await ScanService.deleteScanResult(id);
      await _loadScanResults();
      if (mounted) {
        _showSuccessSnackBar('Scan result deleted');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error deleting scan result: $e');
      }
    }
  }

  Future<void> _clearAllScans() async {
    try {
      for (final result in _scanResults) {
        await ScanService.deleteScanResult(result.id);
      }
      await _loadScanResults();
      if (mounted) {
        _showSuccessSnackBar('All scans cleared');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error clearing scans: $e');
      }
    }
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_sweep_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Clear All Scans'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete all ${_scanResults.length} scan results? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _clearAllScans();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Scan History',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: Colors.grey[200],
        ),
      ),
      actions: [
        if (_scanResults.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded),
            onPressed: _showClearAllDialog,
            tooltip: 'Clear all scans',
          ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Loading scan history...');
    }

    if (_scanResults.isEmpty) {
      return EmptyStateWidget(
        title: 'No scans yet',
        subtitle:
            'Start scanning numbers with your camera\nto see them appear here',
        icon: Icons.document_scanner_rounded,
        buttonText: 'Start Scanning',
        onButtonPressed: () => Navigator.pop(context),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadScanResults,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _scanResults.length,
        itemBuilder: (context, index) {
          final result = _scanResults[index];
          return ScanResultCard(
            result: result,
            onDelete: () => _deleteScanResult(result.id),
          );
        },
      ),
    );
  }
}
